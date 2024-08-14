# frozen_string_literal: true

RSpec.describe ActionMailer::Balancer::DeliveryMethod do # rubocop:disable RSpec/SpecFilePathFormat
  describe '#deliver!' do
    subject(:deliver!) { described_class.new(settings).deliver!(message) }

    let(:settings) do
      {
        delivery_methods: [
          {
            method: :smtp,
            settings: {
              method_num: 1
            },
            weight: 90
          },
          {
            method: :sendmail,
            settings: {
              method_num: 2
            },
            weight: 10
          }
        ]
      }
    end
    let(:message) { instance_double(Mail::Message) }
    let(:weight) { 50 }

    before do
      allow(message).to receive(:delivery_method).with(Mail::SMTP, { method_num: 1 })
      allow(message).to receive(:delivery_method).with(Mail::Sendmail, { method_num: 2 })
      allow(message).to receive(:deliver!)
      allow_any_instance_of(described_class).to receive(:rand).with(1..100).and_return(weight) # rubocop:disable RSpec/AnyInstance
    end

    context 'when settings are not set' do
      let(:settings) { {} }

      it 'raises an error' do
        expect { deliver! }.to raise_error(ActionMailer::Balancer::SettingsError, 'No settings set')
      end
    end

    context 'when delivery methods are not set' do
      let(:settings) { { some_setting: true } }

      it 'raises an error' do
        expect { deliver! }.to raise_error(ActionMailer::Balancer::SettingsError, 'No delivery methods set')
      end
    end

    context 'when first method is chosen' do
      it 'sets correct delivery method' do
        deliver!

        expect(message).to have_received(:delivery_method).with(Mail::SMTP, { method_num: 1 }).once
        expect(message).not_to have_received(:delivery_method).with(Mail::Sendmail, { method_num: 2 })
      end
    end

    context 'when second method is chosen' do
      let(:weight) { 95 }

      it 'sets correct delivery method' do
        deliver!

        expect(message).to have_received(:delivery_method).with(Mail::Sendmail, { method_num: 2 }).once
        expect(message).not_to have_received(:delivery_method).with(Mail::SMTP, { method_num: 1 })
      end
    end

    context 'when weight is not set' do
      let(:settings) do
        {
          delivery_methods: [
            {
              method: :smtp,
              settings: {
                method_num: 1
              }
            },
            {
              method: :sendmail,
              settings: {
                method_num: 2
              },
              weight: 10
            }
          ]
        }
      end

      it 'raises an error' do
        expect { deliver! }.to raise_error(
          ActionMailer::Balancer::SettingsError, 'No weight set for delivery method smtp'
        )
      end
    end
  end
end
