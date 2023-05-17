SUBROUTINE REDO.V.VAL.COMP.ID
*-----------------------------------------------------------------------------
*DESCRIPTION:
*------------
* This routine will update the fields like COMPANY.NAME, BILL.COND, and BILL.TYPE
* depending on value of COMPANY.ID

* Input/Output:
*--------------
* IN : -NA-
* OUT : -NA-
*
* Dependencies:
*---------------
* CALLS : @ID
* CALLED BY :
*
* Revision History:
*------------------------------------------------------------------------------------------
*   Date               who           Reference            Description
* 11-Jan-2010        Ganesh R        ODR2009100480        Initial Creation
* 05-03-2011       Sudharsanan S      PACS00033084       To set a drop down values for local field
* 07-10-2011       Prabhu             PACS00032745       MODIFIED TO SUPPORT EB LOOKUP
*------------------------------------------------------------------------------------------


    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.TELLER
    $INSERT I_F.USER
    $INSERT I_F.REDO.THIRDPRTY.PARAMETER

    GOSUB INIT
    GOSUB OPEN.FILES
    GOSUB PROCESS
RETURN

*---*
INIT:
*---*
*--------------------------*
*Initialising the Variables
*--------------------------*
    LOC.REF.APPLICATION='TELLER'
    LOC.REF.FIELDS='L.TT.CMPNY.NAME':@VM:'L.TT.BILL.TYPE':@VM:'L.TT.BILL.COND'
    LOC.REF.POS=''
    CALL MULTI.GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,LOC.REF.POS)
    L.TT.CMPNY.NAME.POS = LOC.REF.POS<1,1>
    L.TT.BILL.TYPE.POS  = LOC.REF.POS<1,2>
    L.TT.BILL.COND.POS  = LOC.REF.POS<1,3>

RETURN
*---------*
OPEN.FILES:
*---------*
*------------------*
* Calling the Files*
*------------------*
    FN.RTP='F.REDO.THIRDPRTY.PARAMETER'
RETURN
*--------*
PROCESS:
*--------*
*-----------------*
*Updating the Fields
*-----------------*
    REDO.ID             = COMI
    CALL CACHE.READ(FN.RTP,REDO.ID,R.RTP,REDO.ERR)
    IF R.RTP THEN
        GOSUB UPDATE.FIELDS
    END
RETURN
*--------------------------------------------------------------------------
UPDATE.FIELDS:
*-------------------------------------------------------------------------

    R.NEW(TT.TE.LOCAL.REF)<1,L.TT.CMPNY.NAME.POS>=R.RTP<REDO.TP.COMP.NAME>
    R.NEW(TT.TE.LOCAL.REF)<1,L.TT.BILL.TYPE.POS>=R.RTP<REDO.TP.BILL.TYPE>
    VAR.BILL.COND = R.RTP<REDO.TP.BILL.COND>
    CHANGE @VM TO @FM IN VAR.BILL.COND
    CNT.COND.FM = DCOUNT(VAR.BILL.COND,@FM)
*Check with the EB.LOOKUP table to display the description values
    VAR.VIRTUAL.TABLE = 'BILL.COND'
    CALL EB.LOOKUP.LIST(VAR.VIRTUAL.TABLE)
    CNT.VTABLE= DCOUNT(VAR.VIRTUAL.TABLE,@FM)
    VIRTUAL.TABLE.IDS = VAR.VIRTUAL.TABLE<2>        ;*2nd Part of @ID
*----------PACS00032745 -----------------------------------------------------------
    Y.USER.LANG=R.USER<EB.USE.LANGUAGE>
    VIRTUAL.TABLE.VALUES = VAR.VIRTUAL.TABLE<CNT.VTABLE>      ;*Description field values
*---------PACS00032745------------END---------------------------------------------
    CHANGE '_' TO @FM IN VIRTUAL.TABLE.VALUES
    CHANGE '_' TO @FM IN VIRTUAL.TABLE.IDS
    CNT =1
    LOOP
    WHILE CNT LE CNT.COND.FM
        TABLE.IDS = ''
        TABLE.IDS = VAR.BILL.COND<CNT>
        LOCATE TABLE.IDS IN VIRTUAL.TABLE.IDS SETTING POS THEN
            IF NOT(VIRTUAL.TABLE.VALUES<POS,Y.USER.LANG>) THEN
                FORM.ARRAY<1,1,-1> = VIRTUAL.TABLE.VALUES<POS,1>
            END
            ELSE
                FORM.ARRAY<1,1,-1> = VIRTUAL.TABLE.VALUES<POS,Y.USER.LANG>
            END
        END
        CNT += 1
    REPEAT
    R.NEW(TT.TE.LOCAL.REF)<1,L.TT.BILL.COND.POS> = FORM.ARRAY
RETURN
*----------------------------------------------------------------------------
END
