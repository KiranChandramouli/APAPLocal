* @ValidationCode : MjotOTMyNzExNTM4OkNwMTI1MjoxNzAxMTA5NDgxMjk1OklUU1MxOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 27 Nov 2023 23:54:41
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

$PACKAGE APAP.LAPAP
SUBROUTINE L.APAP.GET.TXN.INFO
*--------------------------------------------------------------------------------------------------------------------
*MODIFICATION HISTORY:
*
* DATE              WHO                REFERENCE                 		DESCRIPTION
* 13-07-2023     Conversion tool    R22 Auto conversion       			BP Removed
* 13-07-2023     Harishvikram C   Manual R22 conversion       			No changes
* 27-11-2023	 VIGNESHWARI     ADDED COMMENT FOR INTERFACE CHANGES     SQA-11637 | MONITOR � By Santiago
*---------------------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON                     ;*R22 Auto conversion - Start
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.TELLER
    $INSERT I_F.T24.FUND.SERVICES        ;*R22 Auto conversion - End

    Y.RESULT = "NO"
 ;*Fix SQA-11637 | MONITOR � By Santiago-NEW LINES ADDED-START  
    FN.TELLER = 'F.TELLER'
    F.TELLER  = ''
    CALL OPF(FN.TELLER,F.TELLER)
    
    FN.T24.FUND.SERVICES = 'F.T24.FUND.SERVICES'
    F.T24.FUND.SERVICES = ''
    CALL OPF(FN.T24.FUND.SERVICES,F.T24.FUND.SERVICES)
    
    CALL F.READ(FN.TELLER,COMI,R.TELLER,F.TELLER,TT.ERR)
    Y.OVERRIDE = R.TELLER<TT.TE.OVERRIDE>
    
    IF INDEX(Y.OVERRIDE,'CORREO',1) OR INDEX(Y.OVERRIDE,'EMAIL',1) AND INDEX(Y.OVERRIDE,'YES',1) THEN
        Y.RESULT = "SI"
    END ELSE
        Y.THEIR.REFERENCE = R.TELLER<TT.TE.THEIR.REFERENCE>
        CALL F.READ(FN.T24.FUND.SERVICES,Y.THEIR.REFERENCE,R.T24.FUND.SERVICES,F.T24.FUND.SERVICES,TFS.ERR)
        Y.OVERRIDE = F.T24.FUND.SERVICES<TFS.OVERRIDE>
        IF INDEX(Y.OVERRIDE,'CORREO',1) OR INDEX(Y.OVERRIDE,'EMAIL',1) AND INDEX(Y.OVERRIDE,'YES',1) THEN
            Y.RESULT = "SI"
        END
    END
    
    COMI = Y.RESULT
 ;*Fix SQA-11637 | MONITOR � By Santiago-END
  
*-- VARIALES PARA EJECUTAR SELECT
;*Fix SQA-11637 | MONITOR � By Santiago-COMMENTED-START
*    SEL.FN = "FBNK.TELLER"
*    SEL.LIST = ""
*    NO.REC = ""
*    SEL.ERR = ""
*    SEL.CMD = "SELECT ": SEL.FN :" WITH @ID EQ " : COMI : " AND OVERRIDE LIKE 'L.APAP.SEND.RECEIPT.EMAIL}DESEA RECIBIR EL RECIBO POR CORREO ELECTRONICO? YES'... "
*
*    CALL EB.READLIST(SEL.CMD, SEL.LIST, "", NO.REC, SEL.ERR)
    
*    IF NO.REC GT 0 THEN
*        Y.RESULT = "SI"
*    END ELSE

*-- PARA ABRIR EL ACHIVO CUSTOMER
*        FN.TT = "F.TELLER"
*        FV.TT = ""
*        RS.TT = ""
*        ERR.TT = ""
*
*        CALL OPF(FN.TT, FV.TT)
*        CALL F.READ(FN.TT, COMI, RS.TT, FV.TT, ERR.TT)

*        Y.THEIR.REFERENCE = R.TELLER<TT.TE.THEIR.REFERENCE>
*
*        FINDSTR "T24FS" IN Y.THEIR.REFERENCE SETTING F.P, V.P THEN

*-- VARIALES PARA EJECUTAR SELECT
*            SEL.FN = "FBNK.T24.FUND.SERVICES"
*            SEL.LIST = ""
*            NO.REC = ""
*            SEL.ERR = ""
*            SEL.CMD = "SELECT ": SEL.FN :" WITH @ID EQ " : Y.THEIR.REFERENCE : " AND OVERRIDE LIKE 'L.APAP.SEND.RECEIPT.EMAIL}DESEA RECIBIR EL RECIBO POR CORREO ELECTRONICO? YES'... "
*            CALL EB.READLIST(SEL.CMD, SEL.LIST, "", NO.REC, SEL.ERR)
*
*            IF NO.REC GT 0 THEN
*                Y.RESULT = "SI"
*            END
*        END
*    END
*Fix SQA-11637 | MONITOR � By Santiago-END
RETURN
END
