import Admonition from '@theme/Admonition';
import SemaphoreLogo from '@site/static/img/logo.svg';
import styles from './styles.module.css';

const pricingUrl = "https://semaphoreci.com/pricing";

// Optional argument list of plans. Eg: ['Startup', 'Scaleup']
const Available = ({plans}) => {
    return (
        <Admonition type="note" icon=<SemaphoreLogo/> title="Available On">
            <span className={styles.semaphore}>
                Semaphore Cloud: 
            </span>
            { plans !== undefined ? (
                plans.map((plan) => (
                    <span className={styles.plans}>
                        <a href={pricingUrl} target="_blank" rel="noopener noreferrer">{plan}</a>
                    </span>
                ))) 
                : (
                    <span className={styles.plans}>
                        <a href={pricingUrl} target="_blank" rel="noopener noreferrer">All Plans</a>
                    </span>
                )
            }
        </Admonition>
    );
};

export default Available;

