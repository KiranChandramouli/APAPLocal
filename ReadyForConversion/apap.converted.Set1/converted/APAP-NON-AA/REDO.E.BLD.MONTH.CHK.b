SUBROUTINE REDO.E.BLD.MONTH.CHK(ENQ.DATA)
*-------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : HITESH N
* Program Name  : REDO.E.BLD.MONTH.CHK
* ODR NUMBER    : ODR-2010-03-0137
*-------------------------------------------------------------------------
* Description : This build routine is used to check month (entered in selection criteria )should not be less than the current month

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON

    GOSUB GET.VALUE
    GOSUB PROCESS
RETURN

********
GET.VALUE:
*********
    DATE.VALUE = ''
    YCNT = ''
    CUR.MONTH = ''
    CUR.DATE = ''
****
    DATE.VALUE = ENQ.DATA<4,1>
RETURN
********
PROCESS:
*********
    CHANGE " " TO @FM IN DATE.VALUE
    YCNT = DCOUNT(DATE.VALUE,@FM)
    FOR I.VAR = 1 TO YCNT
        MONTH = DATE.VALUE<I.VAR>[1,6]
        CUR.DATE = TODAY
        CUR.MONTH = CUR.DATE[1,6]

        IF MONTH LT CUR.MONTH THEN
            ENQ.ERROR = "EB-DATE.SHOULD.NOT.LESS"
            CALL STORE.END.ERROR
        END
    NEXT I.VAR
RETURN
END
