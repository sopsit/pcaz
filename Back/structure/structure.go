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
  
	Code       int				`json:"Code"`
	CodeAmount float64			`json:"CodeAmount"`
	Limit      float64			`json:"Cartnum"`
	UseCount   int				`json:"UseCount"`
	CTime      string 			`json:"CTime"`
    ExpirationDate string		`json:"ExpirationDate"`
	
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

	P_category string			`json:"P_category"`
	P_currentprice float64		`json:"P_currentprice"`
	P_Stock_count int			`json:"P_Stock_count"`
	P_brand string				`json:"P_brand"`
	P_model string				`json:"P_model"`
}

