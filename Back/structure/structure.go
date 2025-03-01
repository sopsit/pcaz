package structure

type Client struct {

    Cid            int
	PhoneNumber    string
	Name           string
    LastName       string       
    WalletBalance  float64
	SignupTime     string
	ReferralCode   string
    
}

type DiscountCode struct {
  
	Code       int
	CodeAmount float64
	Limit      float64
	UseCount   int
	CTime      string 
    ExpirationDate string
	
}