SUBROUTINE REDO.APAP.VAL.DATE.MVMT.M
*********************************************************************************************************
*Company   Name    : APAP Bank
*Developed By      : Temenos Application Management
*Program   Name    : REDO.APAP.VAL.DATE.MVMT.M
*--------------------------------------------------------------------------------------------------------
*Description       : This routine ia a validation routine. It is used to check if the Movement type is
*                    been given, then make the field Date of Movement mandatory
*Linked With       : COLLATERAL,DOC.MOVEMENT
*In  Parameter     :
*Out Parameter     :
*Files  Used       : COLLATERAL             As          I Mode
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date            Who                  Reference               Description
*   ------         ------               -------------            -------------
* 27/05/2010        REKHA S         ODR-2009-10-0310 B.180C      Initial Creation
*
*********************************************************************************************************
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.COLLATERAL
*--------------------------------------------------------------------------------------------------------
**********
MAIN.PARA:
**********
    GOSUB PROCESS.PARA

RETURN
*--------------------------------------------------------------------------------------------------------
*************
PROCESS.PARA:
*************

    GOSUB FIND.MULTI.LOCAL.REF
    Y.LOC.MVMT.TYPE=R.NEW(COLL.LOCAL.REF)<1,Y.LOC.MVMT.TYPE.POS>
    Y.LOC.MVMT.DATE=R.NEW(COLL.LOCAL.REF)<1,Y.LOC.DATE.POS>
    Y.COUNT = DCOUNT(Y.LOC.MVMT.TYPE,@VM)
    Y.CNT = 1
    LOOP
    WHILE Y.CNT LE Y.COUNT
        IF Y.LOC.MVMT.TYPE<1,Y.CNT> NE '' AND Y.LOC.MVMT.DATE<1,Y.CNT> EQ '' THEN
            AF = COLL.LOCAL.REF
            AV = Y.LOC.DATE.POS
            AS = Y.CNT
            ETEXT = 'CO-MANDATORY.DATE.MVMT'
            CALL STORE.END.ERROR
            RETURN
        END
        Y.CNT += 1
    REPEAT
*    IF Y.LOC.MVMT.TYPE NE '' AND COMI EQ '' THEN
*       ETEXT = 'CO-MANDATORY.DATE.MVMT'
*      CALL STORE.END.ERROR
* END

RETURN
*--------------------------------------------------------------------------------------------------------
*********************
FIND.MULTI.LOCAL.REF:
*********************
    APPL.ARRAY = 'COLLATERAL'
    FLD.ARRAY  = 'L.CO.MVMT.TYPE':@VM:'L.CO.DATE.MVMT'
    FLD.POS    = ''
    CALL MULTI.GET.LOC.REF(APPL.ARRAY,FLD.ARRAY,FLD.POS)
    Y.LOC.MVMT.TYPE.POS    = FLD.POS<1,1>
    Y.LOC.DATE.POS         = FLD.POS<1,2>

RETURN
*---------------------------------------------------------------------------------------------------------------------------
END
