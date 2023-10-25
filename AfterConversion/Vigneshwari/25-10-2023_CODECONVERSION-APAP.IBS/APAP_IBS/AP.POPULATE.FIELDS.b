* @ValidationCode : MjotMTEzMzQ3MDI3NDpDcDEyNTI6MTY5ODIzNjIzNjIxNTp2aWduZXNod2FyaTotMTotMTowOjA6dHJ1ZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 25 Oct 2023 17:47:16
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : vigneshwari
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : true
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.IBS
*-----------------------------------------------------------------------------
* <Rating>418</Rating>
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------------------------------------------------------------
*Modification HISTORY:
*DATE                          AUTHOR                   Modification                            DESCRIPTION
*25/10/2023                VIGNESHWARI         MANUAL R23 CODE CONVERSION                Remove BP from insert file
*-----------------------------------------------------------------------------------------------------------------------------------

    SUBROUTINE  AP.POPULATE.FIELDS

    $INSERT I_EQUATE
    $INSERT I_COMMON
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.ACCOUNT
    $INSERT I_F.CUSTOMER
    $INSERT I_F.DE.ADDRESS
    $INSERT I_F.REDO.ACH.PARTICIPANTS    ;*MANUAL R23 CODE CONVERSION-Remove BP from insert file
    GOSUB INITIALISE
    GOSUB POPULATE.ORD.CUST
    GOSUB POPULATE.BEN.BANK

    RETURN

***********
INITIALISE:
***********

    FN.ACCOUNT = "F.ACCOUNT"
    F.ACCOUNT = ""
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.CUSTOMER = "F.CUSTOMER"
    F.CUSTOMER = ""
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

    FN.DE.ADDRESS = "F.DE.ADDRESS"
    F.DE.ADDRESS = ""
    CALL OPF(FN.DE.ADDRESS,F.DE.ADDRESS)

    FN.REDO.ACH.PARTICIPANTS = 'F.REDO.ACH.PARTICIPANTS'
    F.REDO.ACH.PARTICIPANTS = ''
    CALL OPF(FN.REDO.ACH.PARTICIPANTS,F.REDO.ACH.PARTICIPANTS)

    L.BEN.BANK.POS = 0
    CALL GET.LOC.REF("FUNDS.TRANSFER" , "L.FTST.ACH.PART" , L.BEN.BANK.POS)

    IF L.BEN.BANK.POS = 0 THEN
        L.BEN.BANK.POS = 113
    END

    L.BEN.BIC.POS = 0
    CALL GET.LOC.REF("REDO.ACH.PARTICIPANTS" , "L.LBTR.BIC" , L.BEN.BIC.POS)

    L.BEN.BK.TYPE.POS = 0
    CALL GET.LOC.REF("REDO.ACH.PARTICIPANTS" , "L.INSTIT.TYPE" , L.BEN.BK.TYPE.POS)
    
    NAME.1 = ""
    STR.ADD  = ""
    TOW.ADD  = ""
    COU.ADD  = ""
    ORD.CUST = ""

    RETURN

******************
POPULATE.ORD.CUST:
******************

    DB.ACC = ""
    DB.ACC = R.NEW(FT.DEBIT.ACCT.NO)

    ER = ''
    R.ACC.DB = ''
    CALL F.READ(FN.ACCOUNT,DB.ACC,R.ACC.DB,F.ACCOUNT,ER)
    IF NOT(ER) THEN
        CU.NO = R.ACC.DB<AC.CUSTOMER>
        IF CU.NO THEN
            ID.ADD =  "DO0010001.C-":CU.NO:".PRINT.1"
            ER = ''
            R.ADD = ''
            CALL F.READ(FN.DE.ADDRESS,ID.ADD,R.ADD,F.DE.ADDRESS,ER)
            IF R.ADD THEN
                NAME.1 = R.ADD<DE.ADD.NAME.1>[1,34]
                STR.ADD = R.ADD<DE.ADD.STREET.ADDRESS>
                TOW.ADD = R.ADD<DE.ADD.TOWN.COUNTY>
                COU.ADD = R.ADD<DE.ADD.COUNTRY>
                ORD.CUST = "/":DB.ACC
                IF NAME.1 THEN
                    ORD.CUST = ORD.CUST:@VM:NAME.1
                END
                IF STR.ADD THEN
                    ORD.CUST = ORD.CUST:@VM:STR.ADD
                END
                IF TOW.ADD THEN
                    ORD.CUST = ORD.CUST:@VM:TOW.ADD
                END
                IF COU.ADD THEN
                    ORD.CUST = ORD.CUST:@VM:COU.ADD
                END
            END
        END
        IF ORD.CUST THEN R.NEW(FT.ORDERING.CUST) = ORD.CUST
* R.NEW(FT.BEN.NAME) = "TEST"
* R.NEW(FT.BK.TO.BK.INFO) = "/REC/CH"
    END

    RETURN
******************
POPULATE.BEN.BANK:
******************
    IF L.BEN.BANK.POS THEN
        ID.REDO.ACH = R.NEW(FT.LOCAL.REF)<1,L.BEN.BANK.POS>
        IF ID.REDO.ACH THEN
            R.ACH    = ""
            BIC.BANK = ""
            BIC.TYPE = ""            
            CALL F.READ(FN.REDO.ACH.PARTICIPANTS,ID.REDO.ACH,R.ACH,F.REDO.ACH.PARTICIPANTS,ER)
            IF R.ACH AND L.BEN.BIC.POS AND L.BEN.BK.TYPE.POS THEN
                BIC.BANK = R.ACH<4,L.BEN.BIC.POS>
                BIC.TYPE = R.ACH<4,L.BEN.BK.TYPE.POS>
*                INSTIT.NAME = R.ACH<FT.RED21.INSTITUTION>
                INSTIT.NAME = R.ACH<REDO.ACH.PARTI.INSTITUTION> ;*MANUAL R23 CODE CONVERSION-this field name is modified
                IF NOT(BIC.BANK) THEN
                    ETEXT = "ID BANCO OBLIAGTORIO"
                    CALL STORE.END.ERROR
                    RETURN
                END
                IF BIC.TYPE[1,2] = "SW" THEN
                    R.NEW(FT.ACCT.WITH.BANK) = "SW.":BIC.BANK
                END ELSE
                    R.NEW(FT.ACCT.WITH.BANK) = BIC.BANK
                END
            END ELSE
                ETEXT = "ID BANCO OBLIAGTORIO"
                CALL STORE.END.ERROR
                RETURN
            END
        END

    END

    RETURN
