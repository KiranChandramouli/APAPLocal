* @ValidationCode : MjoxMDgzODA0OTY2OkNwMTI1MjoxNjgyMzE2NTUwNzQ1OnNhbWFyOi0xOi0xOjA6MDpmYWxzZTpOL0E6REVWXzIwMjEwOC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 24 Apr 2023 11:39:10
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : samar
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE PRO.RPT.MILLAS.LIBERADA.MORA(Y.ARR.ID, Y.FT.ID, Y.RETORNO)
*------------------------------------------------------------------------------------------
*Modification History
*DATE                WHO                         REFERENCE                DESCRIPTION
*24-04-2023       Conversion Tool        R22 Auto Code conversion          INSERT FILE MODIFIED
*24-04-2023       Samaran T               R22 Manual Code Conversion       No Changes
*------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON   ;*R22 AUTO CODE CONVERSION.START
    $INSERT I_EQUATE
    $INSERT I_F.AA.ARRANGEMENT.ACTIVITY
    $INSERT I_F.AA.BILL.DETAILS   ;*R22 AUTO CODE CONVERSION.END

************************************************************
*APERTURA DE ARCHIVOS A UTILIZAR
************************************************************
    FN.AAB = "F.AA.BILL.DETAILS"
    FV.AAB = ""
    CALL OPF(FN.AAB,FV.AAB)
    FN.AAA = 'F.AA.ARRANGEMENT.ACTIVITY'
    FV.AAA = ''
    CALL OPF (FN.AAA,FV.AAA)

************************************************************
*COMANDO DE SELECION - PRINCIPAL
************************************************************
    SEL.CMD = "" ; SEL.LIST = "" ; NO.OF.RECS = "" ; SEL.ERR = ""
    SEL.CMD = "SELECT FBNK.AA.ARRANGEMENT.ACTIVITY WITH ARRANGEMENT EQ " : Y.ARR.ID :  " AND TXN.CONTRACT.ID EQ " : Y.FT.ID
    CALL EB.READLIST(SEL.CMD, SEL.LIST, '',NO.OF.RECS,SEL.ERR)
************************************************************
*INICIALIZACION DE VARIABLES
************************************************************
    Y.RETORNO = "NO"
************************************************************
*LOOP DE PROCESAMIENTO DE DATOS
************************************************************
    LOOP
        REMOVE Y.AAT.ID FROM SEL.LIST SETTING FI.POS
    WHILE Y.AAT.ID DO
        IF Y.AAT.ID NE "" THEN
            GOSUB READ.AAA.ACTIVITY
            GOSUB LBL.AABILLDETAILS
        END
    REPEAT
RETURN

LBL.AABILLDETAILS:
************************************************************
*COMANDO DE SELECION - SECUNDARIO
************************************************************
    SEL.CMD.AAB = ""
    SEL.LIST.AAB = ""
    NO.OF.RECS.AAB = ""
    SEL.ERR.AAB = ""
    Y.REPAY.REF = ''; Y.REPAY.REF = Y.AAT.ID:"-":Y.EFFECTIVE.DATE
    SEL.CMD.AAB = "SELECT ":FN.AAB:" WITH ARRANGEMENT.ID EQ ":Y.ARR.ID
    SEL.CMD.AAB := " AND REPAY.REF EQ ":Y.REPAY.REF:" AND PROPERTY LIKE ...MORA..."
    CALL EB.READLIST(SEL.CMD.AAB, SEL.LIST.AAB, '',NO.OF.RECS.AAB, SEL.ERR.AAB)
    IF SEL.LIST.AAB EQ '' THEN
        SEL.CMD.AAB = "SELECT FBNK.AA.BILL.DETAILS.HIST WITH ARRANGEMENT.ID EQ ":Y.ARR.ID
        SEL.CMD.AAB := " AND REPAY.REF EQ ":Y.REPAY.REF:" AND PROPERTY LIKE ...MORA..."
        CALL EB.READLIST(SEL.CMD.AAB, SEL.LIST.AAB, '',NO.OF.RECS.AAB, SEL.ERR.AAB)
    END
    LOOP
        REMOVE Y.AAB.ID FROM SEL.LIST.AAB SETTING FI.POS
    WHILE Y.AAB.ID DO
        IF Y.AAB.ID NE "" THEN
            Y.RETORNO = "SI"
        END
    REPEAT
RETURN
READ.AAA.ACTIVITY:
    CALL F.READ(FN.AAA,Y.AAT.ID,R.AAA,FV.AAA,ERROR.AA)
    Y.EFFECTIVE.DATE = R.AAA<AA.ARR.ACT.EFFECTIVE.DATE>
RETURN
END
