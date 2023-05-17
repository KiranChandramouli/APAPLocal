*---------------------------------------------------------------------------------------------------------------
* <Rating>-2</Rating>
*--------------------------------------------------------------------------------------------------------------
  SUBROUTINE REDO.ENQ.BLD.CO.CODE.MAP(ENQ.DETAILS)

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON
$INSERT I_F.AZ.ACCOUNT

*** Enquiry build routine to Map value from J-Descriptr selection field to core field***

*ENQ.DETAILS = CHANGE(ENQ.DETAILS, 'CO.CODE.DDOWN', 'CO.CODE')

  LOCATE "CO.CODE.DDOWN" IN ENQ.DETAILS<2,1> SETTING CO.CODE.DDOWN.POS THEN
    ENQ.DETAILS<2,CO.CODE.DDOWN.POS> = "CO.CODE"
  END

  LOCATE "ALL.IN.ONE.PRODUCT" IN ENQ.DETAILS<2,1> SETTING PROD.POS THEN
    ENQ.DETAILS<2,PROD.POS> = "CATEGORY"
  END

  FN.AZ.ACCOUNT = "F.AZ.ACCOUNT"
  F.AZ.ACCOUNT = ""
  CALL OPF(FN.AZ.ACCOUNT,F.AZ.ACCOUNT)

  SEL.CMD = "SELECT " : FN.AZ.ACCOUNT : " WITH INTEREST.RATE NE ORIG.INTEREST.RATE"
  CALL EB.READLIST(SEL.CMD,SEL.LIST,"",NO.OF.REC,ERR)

  LOCATE "@ID" IN ENQ.DETAILS<2,1> SETTING ID.POS ELSE
    IF SEL.LIST THEN
      CHANGE FM TO " " IN SEL.LIST
      ENQ.DETAILS<2,ID.POS> = "@ID"
      ENQ.DETAILS<3,ID.POS> = "EQ"
      ENQ.DETAILS<4,ID.POS> = SEL.LIST
    END
  END
***
  RETURN
END
