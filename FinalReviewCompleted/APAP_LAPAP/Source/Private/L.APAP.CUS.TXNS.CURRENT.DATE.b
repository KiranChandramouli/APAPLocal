* @ValidationCode : MjotMTc5OTc1MTI2MTpVVEYtODoxNjg5MTQzMzc1MjI1OklUU1M6LTE6LTE6MTg2OjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 12 Jul 2023 11:59:35
* @ValidationInfo : Encoding          : UTF-8
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 186
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE L.APAP.CUS.TXNS.CURRENT.DATE(Y.FINAL)
*--------------------------------------------------------------------------------------------------
* Description           : This routine returns a consolidated transactions of a customer on current date
* Developed On          : 13/08/2019
* Developed By          : Anthony Martinez
* Development Reference : ---
*--------------------------------------------------------------------------------------------------
*  M O D I F I C A T I O N S
* ***************************
* Defect Reference       Modified By                    Date of Change        Change Details
* --------               Anthony Martinez               13/08/2019            Creation
*
* 21-APR-2023     Conversion tool    R22 Auto conversion       BP Removed in insert file
* 21-APR-2023      Harishvikram C   Manual R22 conversion      No changes
*--------------------------------------------------------------------------------------------------
    $INSERT I_COMMON ;*R22 Auto conversion - START
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.FUNDS.TRANSFER ;*R22 Auto conversion - END
**----------------------------------------
**ABRIR LA TABLA FBNK.FUNDS.TRANSFER
**----------------------------------------

    GOSUB INIT
    GOSUB GET.TRANSACTIONS

RETURN

INIT:
**-------------------------------------------------------
    SEL.LIST = ""; NO.OF.REC = ""; SEL.ERR = ""; FT.LIST.POS = ""

    TXN.TYPE.FILTER = "OT33 OT30 OT32 OT31 OT37 OT34 OT36 OT35 AC25 AC08 AC28 AC86 AC14 AC90 ACIO AC88 AC2C AC92 AC2D AC2B AC91 AC93 AC87 AC89 AC77"
    LOGIN.NAME = ""
    Y.CUS.ID = ""
    CURRENT.DATE = SUBSTRINGS(CHANGE(OCONV(DATE(),'DYMD'),' ',''), 3, 8)

    LOCATE "CUSTOMER" IN D.FIELDS SETTING CUS.ID.POS THEN
        Y.CUS.ID = D.RANGE.AND.VALUE<CUS.ID.POS>
    END

    LOCATE "LOGIN.NAME" IN D.FIELDS SETTING LOGIN.NAME.POS THEN
        Y.LOGIN.NAME = D.RANGE.AND.VALUE<LOGIN.NAME.POS>
    END

    FN.FT = "F.FUNDS.TRANSFER"; FV.FT = ""; R.FT = ""; ERR.FT = ""
    CALL OPF(FN.FT, FV.FT)

    SEL.CMD = "SELECT FBNK.FUNDS.TRANSFER WITH TRANSACTION.TYPE EQ " : TXN.TYPE.FILTER : " AND DEBIT.CUSTOMER EQ " : Y.CUS.ID : " AND DATE.TIME LIKE " : CURRENT.DATE : "..."
    CALL EB.READLIST(SEL.CMD, SEL.LIST, '', NO.OF.RECS, SEL.ERR)


RETURN
**-------------------------------------------------------


GET.TRANSACTIONS:
**-------------------------------------------------------
    LOOP
        REMOVE Y.FT.ID FROM SEL.LIST SETTING FT.LIST.POS

    WHILE Y.FT.ID DO

        CALL F.READ(FN.FT, Y.FT.ID, R.FT, FV.FT, ERR.FT)

        CALL GET.LOC.REF("FUNDS.TRANSFER", "L.INP.USER.ID", L.INP.USER.ID.POS)
        CALL GET.LOC.REF("FUNDS.TRANSFER", "L.TT.TAX.AMT", L.TT.TAX.AMT.POS)
        CALL GET.LOC.REF("FUNDS.TRANSFER", "L.TT.COMM.AMT", L.TT.COMM.AMT.POS)

        L.TT.TAX.AMT = 0
        L.TT.COMM.AMT = 0
        LOCAL.CHARGE.AMT = 0


        IF R.FT<FT.LOCAL.REF, L.TT.TAX.AMT.POS> THEN
            L.TT.TAX.AMT = R.FT<FT.LOCAL.REF, L.TT.TAX.AMT.POS>
        END

        IF R.FT<FT.LOCAL.REF, L.TT.COMM.AMT.POS> THEN
            L.TT.COMM.AMT = R.FT<FT.LOCAL.REF, L.TT.COMM.AMT.POS>
        END

        IF R.FT<FT.LOCAL.CHARGE.AMT> THEN
            LOCAL.CHARGE.AMT = R.FT<FT.LOCAL.CHARGE.AMT>
        END

        Y.REFERENCE = Y.FT.ID
        Y.TOTAL.AMT = R.FT<FT.LOC.AMT.DEBITED> + L.TT.TAX.AMT + L.TT.COMM.AMT + LOCAL.CHARGE.AMT
        Y.TXN.TYPE  = R.FT<FT.TRANSACTION.TYPE>
        Y.CHANNEL   = "IBS"
        Y.DATETIME  = R.FT<FT.DATE.TIME>


        IF R.FT<FT.LOCAL.REF, L.INP.USER.ID.POS> EQ "USR.IBANK" THEN
            Y.CHANNEL = "APAPPMOVIL"
        END

        Y.FINAL<-1> = Y.REFERENCE : "|" : Y.TOTAL.AMT : "|" : Y.TXN.TYPE : "|" : Y.CHANNEL : "|" : Y.DATETIME

    REPEAT

RETURN
**-------------------------------------------------------

END
