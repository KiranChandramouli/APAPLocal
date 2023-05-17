SUBROUTINE REDO.B.PREVALANCE.STATUS(Y.PGM.ID)
*-------------------------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Program   Name    : REDO.B.PREVALANCE.STATUS
*DESCRIPTION:This routone is used to update the value in ACCOUNT Application besed upon the existing
*status value(L.AC.STATUS1 and L.AC.STATUS2)
* ------------------------------------------------------------------------------------------
* Input/Output:
*--------------
* IN  : Y.PGM.ID
* OUT : -NA-
*
* Dependencies:
*---------------
* CALLS     : -NA-
* CALLED BY : -NA-
*
* Revision History:
*------------------
*   Date             who                 Reference                     Description
*  ------           --------          ---------------                  ------------------
* 11-10-2010     S.Jeyachandran        ODR-2009-08-0490                Initial Creation
* 21-10-2010     S.KAVITHA             ODR-2009-08-0490                Baselined after few logic changes
* 02-05-2011     S.KAVITHA             PACS00055011                    Bug Fixing
* 31-05-2011      RIYAS                PACS00060188                    Bug Fixing
* 19-09-2011      RIYAS                PACS00099905                     Bug Fixing
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.REDO.PREVALANCE.STATUS
    $INSERT I_REDO.B.PREVALANCE.STATUS.COMMON

*-------------------------------------------------------------------------------

    GOSUB PROCESS

    Y.FINAL.STATUS = ''; Y.FM.STATUS='';LOOP.SM.CNTR ='' ; LOOP.FM.CNTR = '' ; STAT.FM.CNTR = ''; STAT.SM.CNTR = ''; Y.STATUS =''
RETURN
*--------------------------------------------------------------------------------
PROCESS:
*--------------------------------------------------------------------------------
    CALL F.READU(FN.ACCOUNT,Y.PGM.ID,R.ACCOUNT,F.ACCOUNT,F.ERR,Y.ERR)
    Y.STATUS.1 = CHANGE(R.ACCOUNT<AC.LOCAL.REF,Y.L.AC.STATUS1.POS>,@VM,@FM)
    Y.STATUS.2 = CHANGE(R.ACCOUNT<AC.LOCAL.REF,Y.L.AC.STATUS2.POS>,@SM,@FM)
    IF Y.STATUS.1 THEN
        Y.STATUS = Y.STATUS.1
    END
    IF Y.STATUS.2 THEN
        Y.STATUS = Y.STATUS.2
    END
    IF Y.STATUS.1 AND Y.STATUS.2 THEN
        Y.STATUS = Y.STATUS.1:@FM:Y.STATUS.2
    END
    Y.STATUS = SORT(Y.STATUS)
    Y.AC.TOTAL.STATUS = DCOUNT(Y.STATUS,@FM)
    GOSUB FM.COUNTER.CHECK
RETURN
*--------------------------------------------------------------------------------------------
FM.COUNTER.CHECK:
*--------------------------------------------------------------------------------------------
    PARAM.STATUS = CHANGE(R.REDO.PREVALANCE.STATUS<REDO.PRE.STATUS>,@VM,@FM)
    PREVALANCE.STATUS = CHANGE(R.REDO.PREVALANCE.STATUS<REDO.PRE.PREVALANT.STATUS>,@VM,@FM)
    STAT.FM.CNTR = DCOUNT(PARAM.STATUS,@FM)
    LOOP.FM.CNTR = 1
    LOOP
    WHILE LOOP.FM.CNTR LE STAT.FM.CNTR
        Y.FM.STATUS = PARAM.STATUS<LOOP.FM.CNTR>
        Y.FM.STATUS = SORT(Y.FM.STATUS)
        Y.FM.STATUS = CHANGE(Y.FM.STATUS,@SM,@FM)
        Y.LOC.TOTAL.STATUS = DCOUNT(Y.FM.STATUS,@FM)
        IF Y.AC.TOTAL.STATUS NE Y.LOC.TOTAL.STATUS ELSE
            Y.FINAL.STATUS = PREVALANCE.STATUS<LOOP.FM.CNTR>
            GOSUB WRITE.RECORD
        END
        LOOP.FM.CNTR + = 1
    REPEAT
RETURN

*--------------------------------------------------------------------------------------------
WRITE.RECORD:
*--------------------------------------------------------------------------------------------
    IF Y.FM.STATUS EQ Y.STATUS THEN
        R.ACCOUNT<AC.LOCAL.REF,Y.L.AC.STATUS.POS> = Y.FINAL.STATUS
* CALL F.WRITE(FN.ACCOUNT,Y.PGM.ID,R.ACCOUNT)
        CALL F.LIVE.WRITE(FN.ACCOUNT,Y.PGM.ID,R.ACCOUNT)

        GOSUB PROGRAM.END
    END ELSE
        R.ACCOUNT<AC.LOCAL.REF,Y.L.AC.STATUS.POS> = ''
*        CALL F.WRITE(FN.ACCOUNT,Y.PGM.ID,R.ACCOUNT)
        CALL F.LIVE.WRITE(FN.ACCOUNT,Y.PGM.ID,R.ACCOUNT)

    END
RETURN
*-----------------------------------------------------------------------------------------------
PROGRAM.END:
*---------------------------------------------------------------------------------------------------
END
