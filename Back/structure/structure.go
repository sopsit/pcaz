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

type CartStatus struct {
	
	 Cartnum int		`json:"Cartnum"`
	 Carts   string		`json:"Carts"`

}

type ProuductInfo struct {
 
	PCategory       string	`json:"PCategory"`
	PBrand          string	`json:"PBrand"`
	PModel          string	`json:"PModel"`
	CartPrice       float64	`json:"CartPrice"`
	PQuantity       int	`json:"PQuantity"`

}

type History struct {

	PInfo   []ProuductInfo `json:"PInfo"`
	TotalPrice   float64	`json:"TotalPrice"`
}

type Info struct {
	ProductBrand string
	ProductModel string
	ProductCategory string
}

type Product struct {

	P_category string
	P_currentprice float64
	P_Stock_count int
	P_brand string
	P_model string
}