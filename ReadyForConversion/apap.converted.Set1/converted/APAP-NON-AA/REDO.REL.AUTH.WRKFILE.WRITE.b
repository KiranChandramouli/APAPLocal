SUBROUTINE REDO.REL.AUTH.WRKFILE.WRITE
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.USER.RELATION
*--------------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*--------------------------------------------------------------------------------
* Description: This is an auth routine which is used to update the workfile to
* maintain the relation codes
*--------------------------------------------------------------------------------
*Modification History:
*-------------------------------------------------------------------------------
*  DATE             WHO         REFERENCE         DESCRIPTION
*  24/04/11        ganesh h     PACS00023889      initial creation
*--------------------------------------------------------------------------------
**************
MAIN.PROCESS:
*************
    IF R.NEW(REDO.USR.RECORD.STATUS) EQ 'INAU' OR R.NEW(REDO.USR.RECORD.STATUS) EQ 'HNAU' THEN
        GOSUB OPEN.FILES
        GOSUB UPDATE.REL.USER
    END ELSE
        IF R.NEW(REDO.USR.RECORD.STATUS) EQ 'RNAU' THEN
            GOSUB OPEN.FILES
            GOSUB DELETE.WORK.FILE

        END

    END

    OLD.USER=RAISE(R.OLD(REDO.USR.REDO.RELATED.USER))
    CURR.USER=RAISE(R.NEW(REDO.USR.REDO.RELATED.USER))
    TOT.OLD.USER=DCOUNT(OLD.USER,@FM)
    TOT.NEW.USER=DCOUNT(CURR.USER,@FM)

    IF TOT.OLD.USER GT TOT.NEW.USER THEN
        GOSUB DELETE.MODIFY.USER
    END ELSE
        IF TOT.NEW.USER GT TOT.OLD.USER THEN
            GOSUB ADD.MODIFY.USER
        END
    END
RETURN


***********
OPEN.FILES:
***********
    FN.REL.WRK.FILE='F.REDO.REL.AUTH.WORKFILE'
    FV.REL.WRK.FILE=''
    CALL OPF(FN.REL.WRK.FILE,FV.REL.WRK.FILE)
RETURN

****************
UPDATE.REL.USER:
***************

    CURR.USER=RAISE(R.NEW(REDO.USR.REDO.RELATED.USER))
    INS ID.NEW BEFORE CURR.USER<-1>
    STORE.CURR.USER=CURR.USER
    TOT.REL.USERS=DCOUNT(CURR.USER,@FM)

    FOR REL.USER=1 TO TOT.REL.USERS

        FIRST.USER=CURR.USER<REL.USER>
        CURR.USER.POS=''
        GOSUB WRITE.REL.USER
    NEXT REL.USER
RETURN

***************
WRITE.REL.USER:
**************

    LOCATE FIRST.USER IN CURR.USER SETTING CURR.USER.POS THEN
        USER.ID=CURR.USER<CURR.USER.POS>
        DEL STORE.CURR.USER<CURR.USER.POS>
    END
    CALL F.WRITE(FN.REL.WRK.FILE,USER.ID,STORE.CURR.USER)
    INS USER.ID BEFORE STORE.CURR.USER<CURR.USER.POS>

RETURN
*****************
DELETE.WORK.FILE:
*****************
    DEL.CURR.USER=RAISE(R.NEW(REDO.USR.REDO.RELATED.USER))
    INS ID.NEW BEFORE DEL.CURR.USER<-1>
    LOOP
        REMOVE DEL.USER.ID FROM DEL.CURR.USER SETTING DEL.POS
    WHILE DEL.USER.ID

        CALL F.DELETE(FN.REL.WRK.FILE,DEL.USER.ID)

    REPEAT
RETURN
*******************
DELETE.MODIFY.USER:
*******************
    FOR USER.DELETE=1 TO TOT.OLD.USER
        LOCATE OLD.USER<USER.DELETE> IN CURR.USER SETTING USER.CURR.POS ELSE

            CALL F.DELETE(FN.REL.WRK.FILE,OLD.USER<USER.DELETE>)
        END

    NEXT USER.DELETE

RETURN
*****************
ADD.MODIFY.USER:
****************
*FOR USER.ADD=1 TO TOT.NEW.USER
*LOCATE CURR.USER<USER.ADD> IN OLD.USER SETTING OLD.USER.POS THEN
* USER.LIST<-1>=CURR.USER<USER.ADD>
*END

*NEXT USER.ADD
    CALL F.WRITE(FN.REL.WRK.FILE,USER.ID,CURR.USER)
RETURN
END
