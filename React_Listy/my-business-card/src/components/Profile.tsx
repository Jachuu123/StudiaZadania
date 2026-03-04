import Avatar from './Avatar';
import Identity from './Identity';

interface ProfileProps {
  name: string;
  title: string;
  image: string;
}

const Profile = ({ name, title, image }: ProfileProps) => (
  <div style={{ display: 'flex', flexDirection: 'column', alignItems: 'center' }}>
    <Avatar src={image} alt={name} />
    <Identity name={name} title={title} />
  </div>
);

export default Profile;