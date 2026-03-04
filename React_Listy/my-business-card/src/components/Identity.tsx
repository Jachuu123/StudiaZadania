interface IdentityProps {
  name: string;
  title: string;
}

const Identity = ({ name, title }: IdentityProps) => (
  <div style={{ margin: '15px 0' }}>
    <h1 style={{ fontSize: '1.8rem', marginBottom: '5px' }}>{name}</h1>
    <p style={{ color: '#646cff', fontWeight: 'bold', letterSpacing: '1px' }}>{title.toUpperCase()}</p>
  </div>
);

export default Identity;