interface AboutProps {
  text: string;
}

const About = ({ text }: AboutProps) => (
  <section style={{ textAlign: 'left', margin: '20px 0' }}>
    <h3 style={{ borderBottom: '1px solid #444' }}>About Me</h3>
    <p style={{ fontSize: '0.9rem', lineHeight: '1.4' }}>{text}</p>
  </section>
);

export default About;