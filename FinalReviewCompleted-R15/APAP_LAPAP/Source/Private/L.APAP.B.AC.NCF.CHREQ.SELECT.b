* @ValidationCode : MjotMTcxMzcyNzk4MjpDcDEyNTI6MTcwMjY1ODM2MzEyMDpJVFNTOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIzX1NQNC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 15 Dec 2023 22:09:23
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R23_SP4.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2023. All rights reserved.
$PACKAGE APAP.LAPAP
*---------------------------------------------------------------------------------------
*MODIFICATION HISTORY:
*DATE          WHO                 REFERENCE               DESCRIPTION
*13-07-2023    CONVERSION TOOL     R22 AUTO CONVERSION     TAM.BP and LAPAP.BP is Removed
*13-07-2023    AJITHKUMAR S        R22 MANUAL CONVERSION   NO CHANGE
*15-05-2023    Edwin D             R22 Code conversion                         COB issues
*----------------------------------------------------------------------------------------
SUBROUTINE L.APAP.B.AC.NCF.CHREQ.SELECT
 
*
* Client Name : APAP
* Description: Routine to generate / issue the NCF for AC.CHARGE.REQUEST table
* Dev By : Ashokkumar
*
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AC.CHARGE.REQUEST
    $INSERT I_F.STMT.ENTRY
    $INSERT I_F.FT.COMMISSION.TYPE
    $INSERT I_F.REDO.NCF.ISSUED  ;*R22 Auto code conversion
    $INSERT I_F.REDO.REPAYMENT.CHARGE ;*R22 Auto code conversion
    $INSERT I_L.APAP.B.AC.NCF.CHREQ.COMMON ;*R22 Auto code conversion


    GOSUB INIT.READ
    GOSUB PROCESS
RETURN


INIT.READ:
*********
    COMM.ID = 'IMP015%'
    ERR.FT.COMMISSION.TYPE = ''; R.FT.COMMISSION.TYPE = ''; YIMP.ACCOUNT = ''; STMT.LIST = ''
    CALL F.READ(FN.FT.COMMISSION.TYPE,COMM.ID,R.FT.COMMISSION.TYPE,F.FT.COMMISSION.TYPE,ERR.FT.COMMISSION.TYPE)
    YIMP.ACCOUNT = R.FT.COMMISSION.TYPE<FT4.CATEGORY.ACCOUNT>
    YIMP.ACCOUNT = YIMP.ACCOUNT[1,12]
RETURN

PROCESS:
********
    SEL.STPRT = "SELECT ":FN.STMT.PRINTED:" WITH @ID LIKE ":YIMP.ACCOUNT:"...-":YLSTDAY
    EXECUTE SEL.STPRT RTNLIST PRT.LIST
*    SEL.STPRNT = 'QSELECT FBNK.STMT.PRINTED'    ; R22 code conversion
*    EXECUTE SEL.STPRNT PASSLIST PRT.LIST RTNLIST STMT.LIST
    STMT.LIST = ''
    LOOP
        REMOVE STP.ID FROM PRT.LIST SETTING STP.POS
    WHILE STP.ID:STP.POS
        CALL F.READ(FN.STMT.PRINTED, STP.ID, R.STP, R.STMT.PRINTER.ID, STD.ERR)
        IF NOT(STMT.LIST) THEN
            STMT.LIST = R.STP
        END ELSE
            STMT.LIST<-1> = R.STP
        END
    REPEAT
    
    SEL.ACREQ = ''; SEL.LIST = ''; SEL.REC = ''; ERR.SEL = ''
    SEL.ACREQ = "SELECT ":FN.AC.CHARGE.REQUEST:" WITH CHARGE.DATE EQ ":DQUOTE(YLSTDAY) ; * R22 code conversion
    CALL EB.READLIST(SEL.ACREQ,SEL.LIST,'',SEL.REC,ERR.SEL)

    SEL.REPAY = ''; SEL.RPLIST = ''; SEL.RPREC = ''; ERR.SELRP = ''
    SEL.REPAY = "SELECT ":FN.REDO.REPAYMENT.CHARGE:" WITH @ID LIKE ":DQUOTE("...":SQUOTE(YLSTDAY)):" AND TRANSACTION LIKE CHG..."  ; * R22 code conversion
    CALL EB.READLIST(SEL.REPAY,SEL.RPLIST,'',SEL.RPREC,ERR.SELRP)

    FINAL.LIST = STMT.LIST:@FM:SEL.LIST:@FM:SEL.RPLIST
    CALL BATCH.BUILD.LIST('',FINAL.LIST)
RETURN

END
