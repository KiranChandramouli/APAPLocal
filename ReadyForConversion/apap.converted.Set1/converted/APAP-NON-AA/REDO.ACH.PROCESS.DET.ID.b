SUBROUTINE REDO.ACH.PROCESS.DET.ID
*--------------------------------------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.ACH.PROCESS.DET.ID
*--------------------------------------------------------------------------------------------------------
*Description  : This is a ID routine to display ID in yyyymmdd.seconds.sequential format
*Linked With  : REDO.ACH.PROCESS
*In Parameter : N/A
*Out Parameter: N/A
*--------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*    Date            Who                  Reference               Description
*   ------         ------               -------------            -------------
* 1 Sep 2010     Swaminathan.S.R       ODR-2009-12-0290         Initial Creation
*--------------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_F.OFS.STATUS.FLAG
    $INSERT I_F.LOCKING


    FN.REDO.ACH.DET = 'F.REDO.ACH.PROCESS.DET'
    F.REDO.ACH.DET = ''
    CALL OPF(FN.REDO.ACH.DET,F.REDO.ACH.DET)


    FN.REDO.ACH.DET.NAU = 'F.REDO.ACH.PROCESS.DET$NAU'
    F.REDO.ACH.DET.NAU = ''
    CALL OPF(FN.REDO.ACH.DET.NAU,F.REDO.ACH.DET.NAU)

    IF GTSACTIVE THEN
        IF OFS$STATUS<STAT.FLAG.FIRST.TIME> THEN
            GOSUB PROCESS.PARA
            RETURN
        END
    END ELSE
        GOSUB PROCESS.PARA
    END
RETURN

**************
PROCESS.PARA:
**************

    IF V$FUNCTION EQ 'I' THEN


        CALL F.READ(FN.REDO.ACH.DET,ID.NEW,R.REDO.ACH.DET,F.REDO.ACH.DET,DET.ERR)
        IF DET.ERR THEN

            CALL F.READ(FN.REDO.ACH.DET.NAU,ID.NEW,R.REDO.ACH.DET.NAU,F.REDO.ACH.DET.NAU,DET.NAU.ERR)

            IF DET.ERR THEN

                FN.LOCKING = 'F.LOCKING'
                F.LOCKING = ''
                CALL OPF(FN.LOCKING,F.LOCKING)

                Y.LOCKING.ID = 'F.REDO.ACH.PROC.DET.FILE'
                GOSUB READ.LOCKING
                IF R.LOCKING EQ '' THEN
                    GOSUB FIRST.NEW.ID
                END ELSE
                    GOSUB GET.NEXT.ID
                END
            END
        END

        RETURN
*--------------------------------------------------------------------------------------------
**********************
READ.LOCKING:
**********************
*REDO.LOCKING record is read for the given locking id
        R.LOCKING   = ''
        LOCKING.ERR = ''
        CALL F.READ(FN.LOCKING,Y.LOCKING.ID,R.LOCKING,F.LOCKING,LOCKING.ERR)

        RETURN
*--------------------------------------------------------------------------------------------------------
************
FIRST.NEW.ID:
************
        R.LOCKING<EB.LOK.CONTENT> = '0001'
        ID.NEW = TODAY:".":TIME():".":'0001'
        GOSUB WRITE.TO.LOCKING

        RETURN
*--------------------------------------------------------------------------------------------------------
***********
GET.NEXT.ID:
***********

        Y.SEQUENCE = R.LOCKING<EB.LOK.CONTENT>
        Y.SEQUENCE += 1
        Y.SEQUENCE=FMT(Y.SEQUENCE,'4"0"R')
        R.LOCKING<EB.LOK.CONTENT> = Y.SEQUENCE
        ID.NEW = TODAY:".":TIME():".":Y.SEQUENCE
        GOSUB WRITE.TO.LOCKING

        RETURN
*---------------------------------------------------------------------------------------------------------
****************
WRITE.TO.LOCKING:
****************
*
        CALL F.WRITE(FN.LOCKING,Y.LOCKING.ID,R.LOCKING)
        CALL JOURNAL.UPDATE('')
        RETURN
*----------------------------------------------------------------------------------------------------------

    END
