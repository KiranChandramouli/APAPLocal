SUBROUTINE REDO.VISA.NOFILE.VERIFY.INFO(RET.ARRAY)
*--------------------------------------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.VISA.NOFILE.VERIFY.INFO
*--------------------------------------------------------------------------------------------------------
*Description  : This is a nofile enquiry attached to REDO.ENQ.VISA.CHGBCK.VERIFY
*
*In Parameter : N/A
*Out Parameter: N/A
*--------------------------------------------------------------------------------------------------------
*--------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*    Date            Who                  Reference               Description
*   ------          ------               -------------            -------------
* 1 Jan 2012     Balagurunathan         PACS00170998              Initial Creation
*--------------------------------------------------------------------------------------------------------


    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.REDO.VISA.OUTGOING



    GOSUB OPEN.FILES
    GOSUB PROCESS

RETURN


*-----------------------------------------------------------------------------------------
OPEN.FILES:
*-----------------------------------------------------------------------------------------
    FN.REDO.VISA.OUTGOING='F.REDO.VISA.OUTGOING'
    F.REDO.VISA.OUTGOING=''
    CALL OPF(FN.REDO.VISA.OUTGOING,F.REDO.VISA.OUTGOING)

    FN.REDO.VISA.GEN.OUT='F.REDO.VISA.GEN.OUT'
    F.REDO.VISA.GEN.OUT=''
    CALL OPF(FN.REDO.VISA.GEN.OUT,F.REDO.VISA.GEN.OUT)
    SEL.LIST=''
    SEL.CNT=0
    SEL.CMD='SELECT ':FN.REDO.VISA.GEN.OUT:' WITH @ID LIKE ...REDO.VISA.OUTGOING'

    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',SEL.CNT,'')

RETURN



*-------------------------------------------------------------------------------------------
PROCESS:
*-------------------------------------------------------------------------------------------

    ID.OUTGOING=''

    LOOP

        REMOVE ID.OUTGOING FROM SEL.LIST SETTING POS.SEL
    WHILE ID.OUTGOING:POS.SEL
        ID.OUTGOING=FIELD(ID.OUTGOING,"*",1)
        CALL F.READ(FN.REDO.VISA.OUTGOING,ID.OUTGOING,R.REDO.VISA.OUTGOING,FN.REDO.VISA.OUTGOING,ERR)
        R.VISA=  R.REDO.VISA.OUTGOING
        OUT.STATUS=R.REDO.VISA.OUTGOING<VISA.OUT.STATUS>
        IF OUT.STATUS EQ 'VERIFYINFO' THEN


            MRCHNT.NAME=  R.VISA<VISA.OUT.MERCHANT.NAME>
            CHANGE '#' TO "@@@" IN MRCHNT.NAME
            ACQ.REF.NUM=R.VISA<VISA.OUT.ACQR.REF.NUM>
            CHANGE '#' TO "@@@" IN ACQ.REF.NUM

            RET.ARRAY.VAL=ID.OUTGOING:'#':R.VISA<VISA.OUT.PROCESS.DATE>:'#':R.VISA<VISA.OUT.TRANSACTION.CODE>:'#':R.VISA<VISA.OUT.ACCOUNT.NUMBER>:'#': R.VISA<VISA.OUT.PURCHASE.DATE>
            RET.ARRAY.VAL=RET.ARRAY.VAL:'#': R.VISA<VISA.OUT.DEST.AMT>:'#': R.VISA<VISA.OUT.SOURCE.AMT>:'#': R.VISA<VISA.OUT.SRC.CCY.CODE>:'#': R.VISA<VISA.OUT.USAGE.CODE>
            RET.ARRAY.VAL=RET.ARRAY.VAL:'#': MRCHNT.NAME:'#': ACQ.REF.NUM:'#': R.VISA<VISA.OUT.AUTH.CODE>:'#': R.VISA<VISA.OUT.DEST.CCY.CODE>:'#': R.VISA<VISA.OUT.MERCH.CATEG.CDE>
            RET.ARRAY.VAL=RET.ARRAY.VAL:'#':R.VISA<VISA.OUT.REASON.CODE>
            RET.ARRAY<-1>=RET.ARRAY.VAL

        END

    REPEAT



RETURN



END
