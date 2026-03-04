interface ContactSectionProps {
  children: React.ReactNode;
}

const ContactSection = ({ children }: ContactSectionProps) => (
  <div style={{ 
    display: 'flex', 
    flexDirection: 'column', 
    gap: '10px', 
    margin: '20px 0',
    textAlign: 'left' 
  }}>
    <h3 style={{ fontSize: '1rem', borderBottom: '1px solid #333', paddingBottom: '5px' }}>Contact</h3>
    {children}
  </div>
);

export default ContactSection;