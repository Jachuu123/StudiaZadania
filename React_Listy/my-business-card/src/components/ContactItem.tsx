interface ContactItemProps {
  icon: string;
  value: string;
}

const ContactItem = ({ icon, value }: ContactItemProps) => (
  <div style={{ display: 'flex', alignItems: 'center', gap: '10px', margin: '8px 0', fontSize: '0.85rem' }}>
    <span>{icon}</span>
    <span>{value}</span>
  </div>
);

export default ContactItem;