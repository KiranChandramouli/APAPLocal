SUBROUTINE MB.SDB.PARAM.FLD.DEFINITIONS

*////////////////////////////////////////////////////////////////////*
* This contains the Field Definitions for the template MD.SDB.PARAM. *
*////////////////////////////////////////////////////////////////////*

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.TRANSACTION
    $INSERT I_F.COMPANY
    $INSERT I_F.ACCOUNT
    $INSERT I_F.CATEGORY
    $INSERT I_F.OFS.SOURCE
    $INSERT I_F.DE.MAPPING
    $INSERT I_F.FT.COMMISSION.TYPE
    $INSERT I_F.DEAL.SLIP.FORMAT
    $INSERT I_F.FT.TXN.TYPE.CONDITION

    MAT F = "" ; MAT N = "" ; MAT T = ""
    MAT CHECKFILE = "" ; MAT CONCATFILE = ""
    ID.CHECKFILE = "" ; ID.CONCATFILE = ""

    ID.F = "MB.SDB.PARAM" ; ID.N = "9" ; ID.T = "COM"
    ID.CHECKFILE = "COMPANY":@FM:EB.COM.COMPANY.NAME

    Z=0

    Z+=1 ; F(Z) = "DEPOSIT.ACCT" ; N(Z) = "16" ; T(Z) = "" ; T(Z)<1> = "INT"
    CHECKFILE(Z) = "ACCOUNT":@FM:AC.ACCOUNT.TITLE.1
    Z+=1 ; F(Z) = "VAT.PERCENT" ; N(Z) = "5..C" ; T(Z) = "A"
    Z+=1 ; F(Z) = "RENT.PL" ; N(Z) = "5.1" ; T(Z) = "" ; T(Z)<1> = ""
    CHECKFILE(Z) = "CATEGORY":@FM:EB.CAT.DESCRIPTION
    Z+=1 ; F(Z) = "VAT.ACCT" ; N(Z) = "16" ; T(Z) = ""; T(Z)<1> = "INT"
    CHECKFILE(Z) = "ACCOUNT":@FM:AC.ACCOUNT.TITLE.1
    Z+=1 ; F(Z) = "DEF.RENT.ACCT" ; N(Z) = "16" ; T(Z) = "" ; T(Z)<1> = "INT"
    CHECKFILE(Z) = "ACCOUNT":@FM:AC.ACCOUNT.TITLE.1
    Z+=1 ; F(Z) = "ADV.RENT.ACCT" ; N(Z) = "16" ; T(Z) = "" ; T(Z)<1> = "INT"
    CHECKFILE(Z) = "ACCOUNT":@FM:AC.ACCOUNT.TITLE.1
    Z+=1 ; F(Z)="CONSOL.DEP.ACCT"   ; N(Z)="5.1" ; T(Z)<2> = "YES_NO"
    Z+=1 ; F(Z) = "DEP.ACCT.DETAIL" ; N(Z) = "5..C" ; T(Z) = "A"
    CHECKFILE(Z) = "CATEGORY":@FM:EB.CAT.DESCRIPTION
    Z+=1 ; F(Z) = "XX<DISC.GROUP" ; N(Z) = "5..C" ; T(Z) = ""
    Z+=1 ; F(Z) = "XX-DISC.FLAT.AMT" ; N(Z) = "5..C" ; T(Z) = "AMT"
    Z+=1 ; F(Z) = "XX>DISC.PERCENT" ; N(Z) = "3..C" ; T(Z) = ""
    Z+=1 ; F(Z) = "RENEW.NOTICE.FREQ" ; N(Z) = "6..C" ; T(Z) = "A"
    Z+=1 ; F(Z) = "2ND.REMINDER.FREQ" ; N(Z) = "6..C" ; T(Z) = "A"
    Z+=1 ; F(Z) = "FREQ.TYPE" ; N(Z) = "15.1" ; T(Z) = ""; T(Z)<2> = 'YEARLY_MONTHLY'
    Z+=1 ; F(Z) = "RENEW.FREQUENCY" ; N(Z) = "15..C" ; T(Z) = "FQU"
    Z+=1 ; F(Z) = "OFS.SOURCE" ; N(Z) = "30.1" ; T(Z) = "" ; T(Z)<1> = "A"
    CHECKFILE(Z) = "OFS.SOURCE":@FM:OFS.SRC.DESCRIPTION
    Z+=1 ; F(Z) = "FT.COMM.1" ; N(Z) = "20" ; T(Z) = "" ; T(Z)<1> = "A"
    CHECKFILE(Z) = "FT.COMMISSION.TYPE":@FM:FT4.DESCRIPTION
    Z+=1 ; F(Z) = "FT.COMM.2" ; N(Z) = "20" ; T(Z) = "" ; T(Z)<1> = "A"
    CHECKFILE(Z) = "FT.COMMISSION.TYPE":@FM:FT4.DESCRIPTION
    Z+=1 ; F(Z) = "RENT.ADV" ; N(Z) = "30" ; T(Z) = "" ; T(Z)<1> = "A"
    CHECKFILE(Z) = "DEAL.SLIP.FORMAT":@FM:EB.DSF.DESCRIPTION
    Z+=1 ; F(Z) = "RENEW.ADV" ; N(Z) = "30" ; T(Z) = "" ; T(Z)<1> = "A"
    CHECKFILE(Z) = "DEAL.SLIP.FORMAT":@FM:EB.DSF.DESCRIPTION
    Z+=1 ; F(Z) = "RENEW.LTR" ; N(Z) = "10" ; T(Z) = "" ; T(Z)<1> = "A"
    CHECKFILE(Z) = "DE.MAPPING":@FM:DE.MAP.DESCRIPTION
    Z+=1 ; F(Z) = "REMINDER.LTR" ; N(Z) = "10" ; T(Z) = "" ; T(Z)<1> = "A"
    CHECKFILE(Z) = "DE.MAPPING":@FM:DE.MAP.DESCRIPTION
    Z+=1 ; F(Z) = "FT.TXN.TYPE.RENT" ; N(Z) = "15" ; T(Z) = "" ; T(Z)<1> = "A"
    CHECKFILE(Z) = "FT.TXN.TYPE.CONDITION":@FM:FT6.DESCRIPTION
    Z+=1 ; F(Z) = "FT.TXN.TYPE.REFUND" ; N(Z) = "15" ; T(Z) = "" ; T(Z)<1> = "A"
    CHECKFILE(Z) = "FT.TXN.TYPE.CONDITION":@FM:FT6.DESCRIPTION
    Z+=1 ; F(Z) = "XX.STAFF.GROUP" ; N(Z) = "35" ; N(Z) = "5..C" ; T(Z) = ""
    Z+=1 ; F(Z) = "LOCAL.REF" ; N(Z) = "35" ; T(Z) = "A" ; T(Z)<3> = "NOINPUT"
    Z+=1 ; F(Z) = "RESERVED.4" ; N(Z) = "35" ; T(Z) = "A" ; T(Z)<3> = "NOINPUT"
    Z+=1 ; F(Z) = "RESERVED.3" ; N(Z) = "35" ; T(Z) = "A" ; T(Z)<3> = "NOINPUT"
    Z+=1 ; F(Z) = "RESERVED.2" ; N(Z) = "35" ; T(Z) = "A" ; T(Z)<3> = "NOINPUT"
    Z+=1 ; F(Z) = "RESERVED.1" ; N(Z) = "35" ; T(Z) = "A" ; T(Z)<3> = "NOINPUT"

    V = Z+9

RETURN

END
