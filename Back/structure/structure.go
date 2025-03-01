package structure

type Client struct {

    Cid            int        `json:"cid"`
	PhoneNumber    string     `json:"phonenumber"`
	Name           string     `json:"name"`
    LastName       string     `json:"lastname"`
    WalletBalance  float64    `json:"walletbalance"`
	SignupTime     string     `json:"signuptime"`
	ReferralCode   string     `json:"referralcode"`
    
}

type DiscountCode struct {
  
	Code       int
	CodeAmount float64
	Limit      float64
	UseCount   int
	CTime      string 
    ExpirationDate string
	
}