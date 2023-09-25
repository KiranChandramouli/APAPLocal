$PACKAGE APAP.REDOAPAP
SUBROUTINE REDO.APAP.VAL.ADMIN.CHQ
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.APAP.VAL.ADMIN.CHQ
*--------------------------------------------------------------------------------------------------------
*Description       : This is a VALIDATION routine, attached to the field SURROGATE.AC, this routine
*                    populates the local field L.TFS.ADMIN.CHQ with the cheque number generated as per
*                    logic in the routine
*Linked With       : Version T24.FUND.SERVICES,REDO.MULTI.TXN
*In  Parameter     : N/A
*Out Parameter     : N/A
*Files  Used       : T24.FUND.SERVICES                   As          I       Mode
*                    REDO.ADMIN.CHQ.PARAM                As          I       Mode
*                    REDO.H.ADMIN.CHEQUES                As          I       Mode
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date               Who                  Reference                 Description
*   ------             -----               -------------              -------------
* 19 July 2010     Shiva Prasad Y      ODR-2009-10-0318 B.126        Initial Creation
*13-07-2023    CONVERSION TOOL     R22 AUTO CONVERSION     FM TO @FM,VM TO @VM
*13-07-2023    VICTORIA S          R22 MANUAL CONVERSION   NO CHANGE

*********************************************************************************************************
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.T24.FUND.SERVICES
    $INSERT I_F.REDO.ADMIN.CHQ.PARAM
    $INSERT I_F.REDO.H.ADMIN.CHEQUES
*--------------------------------------------------------------------------------------------------------
**********
MAIN.PARA:
**********
* This is the para from where the execution of the code starts
    IF MESSAGE EQ 'VAL' THEN
        RETURN
    END
    GOSUB OPEN.PARA
    GOSUB PROCESS.PARA

RETURN
*--------------------------------------------------------------------------------------------------------
**********
OPEN.PARA:
**********
* In this para of the code, file variables are initialised and opened

    FN.REDO.ADMIN.CHQ.PARAM = 'F.REDO.ADMIN.CHQ.PARAM'
    F.REDO.ADMIN.CHQ.PARAM = ''
    CALL OPF(FN.REDO.ADMIN.CHQ.PARAM,F.REDO.ADMIN.CHQ.PARAM)

    FN.REDO.H.ADMIN.CHEQUES = 'F.REDO.H.ADMIN.CHEQUES'
    F.REDO.H.ADMIN.CHEQUES  = ''
    CALL OPF(FN.REDO.H.ADMIN.CHEQUES,F.REDO.H.ADMIN.CHEQUES)

RETURN
*--------------------------------------------------------------------------------------------------------
*************
PROCESS.PARA:
*************
* This is the main processing para
    Y.TXN.CODES = R.NEW(TFS.TRANSACTION)
    Y.FLAG = ''

    LOCATE 'ADMCHQGOVWITTAX' IN Y.TXN.CODES<1,1> SETTING Y.TXN.POS THEN
        Y.FLAG += 1
        GOSUB PROCESS.ADMIN.CHQ
    END

    LOCATE 'ADMCHQGOVWOTAX'IN Y.TXN.CODES<1,1> SETTING Y.TXN.POS THEN
        Y.FLAG += 1
        GOSUB PROCESS.ADMIN.CHQ
    END

    LOCATE 'ADMCHQOTHERS'IN Y.TXN.CODES<1,1> SETTING Y.TXN.POS THEN
        Y.FLAG += 1
        GOSUB PROCESS.ADMIN.CHQ
    END

RETURN
*--------------------------------------------------------------------------------------------------------
******************
PROCESS.ADMIN.CHQ:
******************
* In this para of the code, the local references, PARAMETER checks and  a selct admin cheque
    GOSUB FIND.MULTI.LOCAL.REF
    GOSUB CHECK.PARAMETER
    GOSUB SELECT.ADMIN.CHEQUE

RETURN
*--------------------------------------------------------------------------------------------------------
****************
CHECK.PARAMETER:
****************
* In this para of the code, the PARAMETER is checked for item codes

    REDO.ADMIN.CHQ.PARAM.ID = 'SYSTEM'
    GOSUB READ.REDO.ADMIN.CHQ.PARAM
    IF NOT(R.REDO.ADMIN.CHQ.PARAM) THEN
        RETURN
    END
    Y.SURR.ACC = COMI
    Y.PARM.ACC = R.REDO.ADMIN.CHQ.PARAM<ADMIN.CHQ.PARAM.ACCOUNT>
    CHANGE @VM TO @FM IN Y.PARM.ACC ;*R22 AUTO CONVERSION

    LOCATE Y.SURR.ACC IN Y.PARM.ACC<1> SETTING Y.POS THEN
        Y.ITEM.CODE = R.REDO.ADMIN.CHQ.PARAM<ADMIN.CHQ.PARAM.ITEM.CODE,Y.POS>
    END

RETURN
*--------------------------------------------------------------------------------------------------------
********************
SELECT.ADMIN.CHEQUE:
********************
* In this para of the code, a CHEQUE is selected from Admin Cheques
    IF NOT(Y.ITEM.CODE) THEN
        RETURN
    END
    IF R.NEW(TFS.LOCAL.REF)<1,LOC.L.TFS.ADMIN.CHQ.POS,Y.FLAG> THEN
        RETURN
    END
    SEL.CMD = 'SSELECT ':FN.REDO.H.ADMIN.CHEQUES:' WITH ITEM.CODE EQ ':Y.ITEM.CODE:' AND BRANCH.DEPT EQ ':ID.COMPANY:' AND STATUS EQ AVAILABLE BY SERIAL.NO'
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,SEL.ERR)
    R.NEW(TFS.LOCAL.REF)<1,LOC.L.TFS.ADMIN.CHQ.POS,Y.FLAG> = SEL.LIST<1,1>

RETURN
*--------------------------------------------------------------------------------------------------------
**************************
READ.REDO.ADMIN.CHQ.PARAM:
**************************
* In this para of the code, file REDO.ADMIN.CHQ.PARAM is read
    R.REDO.ADMIN.CHQ.PARAM  = ''
    REDO.ADMIN.CHQ.PARAM.ER = ''
    CALL CACHE.READ(FN.REDO.ADMIN.CHQ.PARAM,REDO.ADMIN.CHQ.PARAM.ID,R.REDO.ADMIN.CHQ.PARAM,REDO.ADMIN.CHQ.PARAM.ER)

RETURN
*--------------------------------------------------------------------------------------------------------
*********************
FIND.MULTI.LOCAL.REF:
*********************
* In this para of the code, local reference field positions are obtained
    APPL.ARRAY = 'T24.FUND.SERVICES'
    FLD.ARRAY = 'L.TFS.ADMIN.CHQ'
    FLD.POS = ''
    CALL MULTI.GET.LOC.REF(APPL.ARRAY,FLD.ARRAY,FLD.POS)
    LOC.L.TFS.ADMIN.CHQ.POS  =  FLD.POS<1,1>

RETURN
*--------------------------------------------------------------------------------------------------------
END       ;* End of Program
