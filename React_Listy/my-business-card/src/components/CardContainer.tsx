interface CardProps {
  children: React.ReactNode;
}

const CardContainer = ({ children }: CardProps) => (
  <div style={{
    background: '#1a1a1a',
    color: 'white',
    padding: '40px',
    borderRadius: '24px',
    boxShadow: '0 20px 40px rgba(0,0,0,0.4)',
    maxWidth: '400px',
    margin: '20px auto',
    border: '1px solid #333'
  }}>
    {children}
  </div>
);

export default CardContainer;