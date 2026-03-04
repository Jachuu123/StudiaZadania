interface AvatarProps {
  src: string;
  alt: string;
}

const Avatar = ({ src, alt }: AvatarProps) => (
  <img 
    src={src} 
    alt={alt} 
    style={{ borderRadius: '50%', width: '100px', height: '100px', objectFit: 'cover', border: '3px solid #646cff' }} 
  />
);

export default Avatar;