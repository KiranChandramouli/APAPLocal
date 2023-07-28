* @ValidationCode : MjoyODc5Njg3MTA6Q3AxMjUyOjE2ODE5OTU5ODc5NjM6SVRTUzotMTotMToyNDc6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 20 Apr 2023 18:36:27
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 247
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.E.NOF.USER.LOG(Y.FINAL.ARR)
*--------------------------------------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.B.UPD.USER.LOG
*--------------------------------------------------------------------------------------------------------
*Description  :  This is a NOFILE routine attached to the enquiry REDO.APAP.NOF.USER.LOG to
*                 extract the data related to failed login for a user
*                 It refers to the local table REDO.L.USER.LOG
*In Parameter : N/A
*Out Parameter: N/A
*--------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*    Date            Who                  Reference               Description
*   ------         ------               -------------            -------------
* 08 NOV  2010     SRIRAMAN.C                                     Initial Creation
* 27 JUL  2011       RIYAS              PACS00090247              SEL CMD FOR ALL USERS
* 01 May 2015      Ashokkumar           PACS00310287              Changed to update IP address for all cases.

* 13-APR-2023     Conversion tool   R22 Auto conversion        FM TO @FM, VM to @VM, SM to @SM, I to I.VAR
* 13-APR-2023      Harishvikram C   Manual R22 conversion      No changes
*--------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_REDO.B.UPD.USER.LOG.COMMON
    $INSERT I_F.REDO.L.USER.LOG
    $INSERT I_F.TAM.HOST.DETAILS.TRACE


    GOSUB INIT
    GOSUB LOCATE.PROCESS
RETURN
*------------------------------------------------------------------------------
INIT:
    FN.LOGG = 'F.REDO.L.USER.LOG'
    F.LOGG =''
    CALL OPF(FN.LOGG,F.LOGG)
    Y.USER = ''

    FN.TAM.HOST.DETAILS.TRACE = "F.TAM.HOST.DETAILS.TRACE"
    F.TAM.HOST.DETAILS.TRACE = ""
    CALL OPF(FN.TAM.HOST.DETAILS.TRACE,F.TAM.HOST.DETAILS.TRACE)
    R.TAM.HOST.DETAILS.TRACE = ""
***
RETURN
*---------------------------------------------------------------------------------
LOCATE.PROCESS:
*---------------------------------------------------------------------------------
    LOCATE "USER"  IN D.FIELDS<1> SETTING POS THEN
        Y.USER=D.RANGE.AND.VALUE<POS>
        GOSUB CALL.READ
    END ELSE
        GOSUB SEL.CMD
    END
RETURN

SEL.CMD:
*----------------------------------------------------------------
    SEL.CMD="SELECT ":FN.LOGG
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,RET.CODE)
    LOOP
        REMOVE Y.USER FROM SEL.LIST SETTING POS
    WHILE Y.USER:POS
        GOSUB CALL.READ
    REPEAT
RETURN
*-----------------------------------------------------
CALL.READ:
*------------------------------------------------------
    Y.VALID.OP = '1':@VM:'2':@VM:'3':@VM:'8':@VM:'9':@VM:'4'
    LOCATE "DATE" IN D.FIELDS<1> SETTING POS THEN
        Y.DATE=D.RANGE.AND.VALUE<POS>
        Y.DATE.OPERAND=D.LOGICAL.OPERANDS<POS>
        IF Y.DATE.OPERAND MATCHES Y.VALID.OP THEN
        END ELSE
            ENQ.ERROR = 'EB-INVALID.OPERATOR'
            RETURN
        END
    END
    REDO.ERR = ''; R.REDO = ''
    CALL F.READ(FN.LOGG,Y.USER,R.REDO,F.LOGG,REDO.ERR)
*    CALL F.READ(FN.TAM.HOST.DETAILS.TRACE,Y.USER,R.TAM.HOST.DETAILS.TRACE,F.TAM.HOST.DETAILS.TRACE,TRACE.ERR)
*    Y.IP.ADDRESS = R.TAM.HOST.DETAILS.TRACE<HOST.DET.IP.ADDRESS>
*    Y.HOST.NAME = R.TAM.HOST.DETAILS.TRACE<HOST.DET.HOST.NAME>

    IF REDO.ERR EQ '' THEN
        B.DATE = R.REDO<REDO.PRO.LOGIN.DATE>
        CHANGE @VM TO @FM IN B.DATE
        B.TIME = R.REDO<REDO.PRO.LOGINTIME>
        CHANGE @VM TO @FM IN B.TIME
        B.REMARK=R.REDO<REDO.PRO.REMARK>
        CHANGE @VM TO @FM IN B.REMARK
*        YCLIENT.IP = R.REDO<REDO.PRO.CLIENT.IP>
*        CHANGE VM TO FM IN YCLIENT.IP
        SER.CNT = DCOUNT(B.DATE,@FM)

        IF Y.DATE NE '' THEN
            GOSUB CASE.CONDITION
        END ELSE
            GOSUB LOOP.SER.CNT
        END
    END
RETURN

LOOP.SER.CNT:
*************
    FOR I.VAR=1 TO SER.CNT
        GOSUB ENQ.REC.UPDATE
    NEXT I.VAR
RETURN

*------------------------------------------------------
CASE.CONDITION:
*------------------------------------------------------
    FOR I.VAR=1 TO SER.CNT
        BEGIN CASE
            CASE Y.DATE.OPERAND EQ 1
                IF B.DATE<I.VAR> EQ Y.DATE THEN
                    GOSUB ENQ.REC.UPDATE
                END
            CASE Y.DATE.OPERAND EQ 2
                DAT1 = FIELD(Y.DATE, @SM, 1)
                DAT2 = FIELD(Y.DATE, @SM, 2)
                IF B.DATE<I.VAR> GE DAT1 AND B.DATE<I.VAR> LE DAT2 THEN
                    GOSUB ENQ.REC.UPDATE
                END
            CASE Y.DATE.OPERAND EQ 3
                IF B.DATE<I.VAR> LT Y.DATE THEN
                    GOSUB ENQ.REC.UPDATE
                END
            CASE Y.DATE.OPERAND EQ 8
                IF B.DATE<I.VAR> LE Y.DATE THEN
                    GOSUB ENQ.REC.UPDATE
                END
            CASE Y.DATE.OPERAND EQ 9
                IF B.DATE<I.VAR> GE Y.DATE THEN
                    GOSUB ENQ.REC.UPDATE
                END
            CASE Y.DATE.OPERAND EQ 4
                IF B.DATE<I.VAR> GT Y.DATE THEN
                    GOSUB ENQ.REC.UPDATE
                END
        END CASE
    NEXT I.VAR
RETURN

ENQ.REC.UPDATE:
*-----------------------------------------------------
    LOCATE B.DATE<I.VAR> IN B.DATE SETTING B.DATE.POS THEN
        Y.DAT = B.DATE<I.VAR>
        Y.TIME = B.TIME<B.DATE.POS>
        Y.REMARK = B.REMARK<B.DATE.POS>
*        Y.CLIENT.IP = YCLIENT.IP<B.DATE.POS>
        Y.FINAL.ARR<-1>= Y.USER:'*':Y.TIME:'*':Y.DAT:'*':Y.REMARK
    END
RETURN
END
*---------------------------------------------------------------------------------
