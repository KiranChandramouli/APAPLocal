* @ValidationCode : MjoxMDE5OTY3NjI0OkNwMTI1MjoxNjgyMzMxMzIyMTU1OklUU1M6LTE6LTE6Mzk0OjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 24 Apr 2023 15:45:22
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 394
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE L.APAP.ENQ.PAGO.PRESTAMO.NAU(Y.FINAL)
*-----------------------------------------------------------------------------
*MODIFICATION HISTORY:
*
* DATE              WHO                REFERENCE                 DESCRIPTION
* 21-APR-2023     Conversion tool    R22 Auto conversion        F.READ to CACHE.READ, BP Removed in insert file
* 21-APR-2023      Harishvikram C   Manual R22 conversion      No changes
*-----------------------------------------------------------------------------
    $INSERT I_COMMON ;*R22 Auto conversion - START
    $INSERT I_EQUATE
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.FT.TXN.TYPE.CONDITION
    $INSERT I_F.COMPANY ;*R22 Auto conversion - END

*PARA ABRIR EL ACHIVO DE FUNDS.TRANSFER$NAU
    FN.FT = "F.FUNDS.TRANSFER$NAU"
    FV.FT = ""
    CALL OPF(FN.FT, FV.FT)

*PARA ABRIR EL ACHIVO DE FT.TXN.TYPE.CONDITION
    FN.FTTC = "F.FT.TXN.TYPE.CONDITION"
    FV.FTTC = ""
    CALL OPF(FN.FTTC, FV.FTTC)

*PARA ABRIR EL ACHIVO DE COMPANY
    FN.COM = "F.COMPANY"
    FV.COM = ""
    CALL OPF(FN.COM, FV.COM)

    R.FT = ""
    FT.ERR = ""

    R.FTTC = ""
    FTTC.ERR = ""

    R.COM = ""
    COM.ERR = ""

    SEL.LIST = ""
    NO.OF.REC = ""
    SEL.ERR = ""

* FORMAMOS EL COMANDO A EJECUTAR
    SEL.CMD = "SELECT " : FN.FT : " WITH TRANSACTION.TYPE EQ 'ACPO' 'ACRP' 'ACWF' 'ACMO' 'ACPN' 'ACCP' 'ACPA' 'ACQA' 'ACQP'"

* REALIZAMOS LA LLAMADA
    CALL EB.READLIST(SEL.CMD, SEL.LIST,"", NO.OF.REC, SEL.ERR)

    LOOP
        REMOVE Y.FT.ID FROM SEL.LIST SETTING FT.POS

    WHILE Y.FT.ID DO

        CALL F.READ(FN.FT,Y.FT.ID,R.FT, FV.FT, FT.ERR)

        Y.TRX.TYPE = R.FT<FT.TRANSACTION.TYPE>
        Y.DB.ACCT.NO = R.FT<FT.DEBIT.ACCT.NO>
        Y.VAL.DATE = R.FT<FT.DEBIT.VALUE.DATE>
        Y.CR.AMOUNT = R.FT<FT.CREDIT.AMOUNT>
        Y.CR.ACCT.NO = R.FT<FT.CREDIT.ACCT.NO>
        Y.DATE.TIME = R.FT<FT.DATE.TIME>
        Y.PR.DATE = R.FT<FT.PROCESSING.DATE>
        Y.CO.CODE = R.FT<FT.CO.CODE>
        Y.INPUTTER = FIELD(R.FT<FT.INPUTTER>,"_",2)
        Y.AUTHO = FIELD(R.FT<FT.AUTHORISER>,"_",2)

        CALL CACHE.READ(FN.FTTC, Y.TRX.TYPE, R.FTTC, FTTC.ERR) ;*R22 Auto conversion
        Y.TYPE.DESC = R.FTTC<FT6.DESCRIPTION>

        CALL CACHE.READ(FN.COM, Y.CO.CODE, R.COM, COM.ERR) ;*R22 Auto conversion
        Y.COM.NAME = R.COM<EB.COM.COMPANY.NAME>

        Y.FINAL<-1> = Y.FT.ID:"|":Y.TRX.TYPE:"|":Y.DB.ACCT.NO:"|":Y.TYPE.DESC:"|":Y.CR.AMOUNT:"|":Y.CR.ACCT.NO:"|":Y.DATE.TIME:"|":Y.PR.DATE:"|":Y.CO.CODE:"|":Y.INPUTTER:"|":Y.AUTHO:"|":Y.COM.NAME

    REPEAT

END
