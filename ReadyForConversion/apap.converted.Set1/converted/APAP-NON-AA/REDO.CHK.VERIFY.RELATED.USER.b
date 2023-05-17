SUBROUTINE REDO.CHK.VERIFY.RELATED.USER
*-----------------------------------------------------------------------------
*DESCRIPTION:
*------------
* This routine is linked with VERSION.CONTROL & used to check the relation between
* the INPUTTER and the AUTHORISER, If the inputter related with the authoriser then
* the function does not allow the particular user to authorise the record

* Dependencies:
*---------------
* CALLS : -NA-
* CALLED BY : -NA-

*-----------------------------------------------------------------------------

* Revision History
* ----------------

* Date             Name                      Reference             Description
* ----             ----                      ---------             -----------

* 10-JUL-09   KARTHI.K.R(TEMENOS)            ODR-2009-06-021       Initial Version
* 27-04-11    GANESH H                       PACS00023889          MODIFICAION
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_F.REDO.USER.RELATION
    $INSERT I_F.STANDARD.SELECTION


    GOSUB INITIALISE
    GOSUB PROCESS

RETURN

PROCESS:
*-------



    IF V$FUNCTION EQ 'S' OR V$FUNCTION EQ 'A' THEN

        R.SS.REC = ''
        CALL GET.STANDARD.SELECTION.DETS(APPLICATION, R.SS.REC)
        IF R.SS.REC NE '' THEN
            LOCATE 'INPUTTER' IN R.SS.REC<SSL.SYS.FIELD.NAME, 1> SETTING Y.POS THEN
                Y.INPUTTER.POS = R.SS.REC<SSL.SYS.FIELD.NO, Y.POS>
            END ELSE
                Y.INPUTTER.POS = 0
            END
        END ELSE
            Y.INPUTTER.POS = 0
        END

        IF Y.INPUTTER.POS NE 0 THEN
            Y.VM.COUNT = DCOUNT(R.NEW(Y.INPUTTER.POS), @VM)
            Y.INPUT.USER = R.NEW(Y.INPUTTER.POS)<1, Y.VM.COUNT>
            IF INDEX(Y.INPUT.USER, '_', 1) THEN
                Y.INPUT.USER = Y.INPUT.USER['_', 2, 1]
            END

            R.REDO.USER.RELATION = ''
            Y.READ.ERR = ''
*PACS00023889-S
            CALL F.READ(FN.REL.WRK.FILE, Y.INPUT.USER, R.REDO.USER.RELATION, FV.REL.WRK.FILE, Y.READ.ERR)

            IF R.REDO.USER.RELATION  THEN

                LOCATE OPERATOR IN R.REDO.USER.RELATION<1> SETTING Y.POS THEN

                    AV='FT.INPUTTER'
                    E = 'EB-USER.REL.USER'
                    CALL ERR

                END
*PACS00023889-E
            END
        END

    END

RETURN

INITIALISE:
*----------

    FN.REDO.USER.RELATION = 'F.REDO.USER.RELATION'
    F.REDO.USER.RELATION = ''
    CALL OPF(FN.REDO.USER.RELATION,F.REDO.USER.RELATION)
*PACS00023889-S
    FN.REL.WRK.FILE='F.REDO.REL.AUTH.WORKFILE'
    FV.REL.WRK.FILE=''
    CALL OPF(FN.REL.WRK.FILE,FV.REL.WRK.FILE)
*PACS00023889-E
RETURN
*-----------------------------------------------------------------------------
END
*-----------------------------------------------------------------------------
