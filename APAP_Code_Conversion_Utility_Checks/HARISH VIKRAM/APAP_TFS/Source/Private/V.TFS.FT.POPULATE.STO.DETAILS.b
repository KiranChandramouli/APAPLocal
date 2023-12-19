* @ValidationCode : Mjo4MjM1NzM0MDU6Q3AxMjUyOjE2OTg3NTA2NzQ3Mjk6SVRTUzE6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 31 Oct 2023 16:41:14
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TFS
*-----------------------------------------------------------------------------
* <Rating>60</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE V.TFS.FT.POPULATE.STO.DETAILS
*
* Version subroutine attached to FUNDS.TRANSFER, as field validation routine
* to TRANSACTION.TYPE field, to pull in the Standing Order dets (here, Payee
* dets, based on STO ID passed in Local Ref field 'TFS.STO.ID' in FT
*
*Modification History:
*DATE                 WHO                    REFERENCE                     DESCRIPTION
*26/10/2023         Suresh             R22 Manual Conversion            USPLATFORM.BP File Removed, CALL REFRESH.FIELD Changed
*--------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.FUNDS.TRANSFER

    $INSERT I_F.STANDING.ORDER
    $INSERT I_F.STO.BULK.CODE

    $INCLUDE I_F.T24.FUND.SERVICES ;*R22 Manual Conversion
    $USING EB.Display


    GOSUB INIT
    GOSUB PRELIM.CONDS
    IF PROCESS.GOAHEAD THEN
        GOSUB PROCESS
    END

    IF ETEXT THEN
        CALL STORE.END.ERROR
    END ELSE
        IF DEFAULTED.FIELD THEN
*            CALL REFRESH.FIELD(DEFAULTED.FIELD,'')
            EB.Display.RefreshField(DEFAULTED.FIELD,'')   ;*R22 Manual Conversion
        END
    END

RETURN
*--------------------------------------------------------------------------
INIT:

    PROCESS.GOAHEAD = 1
    STO.ID = ''
*
    FN.STO = 'F.STANDING.ORDER' ; F.STO = ''
    FN.SBC = 'F.STO.BULK.CODE' ; F.SBC = ''
    FN.CATEG = 'F.CATEGORY' ; F.CATEG = ''
*
    CALL US.GET.LOCAL.REF.POS.ARRAY('FUNDS.TRANSFER','TFS.STO.ID',STO.ID.POS,STO.ID.LREF.ERR)
    IF STO.ID.LREF.ERR THEN
        ETEXT = STO.ID.LREF.ERR
        PROCESS.GOAHEAD = 0
    END

RETURN
*-------------------------------------------------------------------------
PRELIM.CONDS:

    IF AF EQ FT.LOCAL.REF AND AV EQ STO.ID.POS THEN
        STO.ID = COMI
    END ELSE
        STO.ID = R.NEW(FT.LOCAL.REF)<1,STO.ID.POS>
    END

    IF NOT(STO.ID) THEN PROCESS.GOAHEAD = 0

RETURN
*-------------------------------------------------------------------------
PROCESS:

    CALL F.READ(FN.STO,STO.ID,R.STO,F.STO,ERR.STO)
    IF R.STO THEN
        GOSUB GET.PAYEE.DETAILS

*
        R.NEW(FT.BEN.CUSTOMER) = BENEFICIARY
        DEFAULTED.FIELD<-1> = FT.BEN.CUSTOMER

        R.NEW(FT.BEN.ACCT.NO) = BEN.ACCT.NO
        DEFAULTED.FIELD<-1> = FT.BEN.ACCT.NO

        R.NEW(FT.ACCT.WITH.BANK) = ACCT.WITH.BANK
        DEFAULTED.FIELD<-1> = FT.ACCT.WITH.BANK

        R.NEW(FT.BC.BANK.SORT.CODE) = SORT.CODE
        DEFAULTED.FIELD<-1> = FT.BC.BANK.SORT.CODE

        R.NEW(FT.PAYMENT.DETAILS) = R.STO<STO.PAYMENT.DETAILS>
        DEFAULTED.FIELD<-1> = FT.PAYMENT.DETAILS
    END

RETURN
*--------------------------------------------------------------------------
GET.PAYEE.DETAILS:

    BENEFICIARY = '' ; BEN.ACCT.NO = '' ; ACCT.WITH.BANK = '' ; SORT.CODE = ''

    BENEFICIARY = R.STO<STO.BENEFICIARY>
    IF BENEFICIARY THEN
        BEN.ACCT.NO = R.STO<STO.BEN.ACCT.NO>
        ACCT.WITH.BANK = R.STO<STO.ACCT.WITH.BANK>
        SORT.CODE = R.STO<STO.BANK.SORT.CODE>
    END ELSE
        SBC.ID = R.STO<STO.BULK.CODE.NO>
        IF SBC.ID THEN
            CALL F.READ(FN.SBC,SBC.ID,R.SBC,F.SBC,ERR.SBC)
            IF R.SBC THEN
                BENEFICIARY = R.SBC<STO.BC.BENEFICIARY>
                BEN.ACCT.NO = R.SBC<STO.BC.BENEFICIARY.ACCTNO>
                ACCT.WITH.BANK = R.SBC<STO.BC.ACCT.WITH.BANK>
                SORT.CODE = R.SBC<STO.BC.BANK.SORT.CODE>
            END
        END
    END

RETURN
*--------------------------------------------------------------------------
END
