$PACKAGE APAP.TAM
*---------------------------------------------------------------------------------------
*MODIFICATION HISTORY:
*DATE           WHO                 REFERENCE               DESCRIPTION
*24-APR-2023    CONVERSION TOOL     R22 AUTO CONVERSION     ++ TO +=1
*24-APR-2023    CONVERSION TOOL     R22 AUTO CONVERSION     T TO C$T24.SESSION.
*24-APR-2023    VICTORIA S          R22 MANUAL CONVERSION   NO CHANGE
*----------------------------------------------------------------------------------------
SUBROUTINE REDO.UPDT.FXSN.RUN
*---------------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : GANESH R
* Program Name  : REDO.UPDT.FXSN.RUN
* ODR NUMBER    : ODR-2010-01-0213
*----------------------------------------------------------------------------------
* Description : This run routine is triggered to update the FXSN table with records
* In parameter : None
* out parameter : None
*----------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.LOCKING
    $INSERT I_F.USER
    $INSERT I_F.REDO.FOREX.SEQ.NUM
    $INSERT I_F.REDO.UPDT.FXSN

    GOSUB INITIALISATION
    GOSUB OPEN.FILES
    GOSUB PROCESS
RETURN

*----------------------------------------------------------------------------------
INITIALISATION:
*----------------------------------------------------------------------------------
    LOCK.ID='FBNK.REDO.FOREX.SEQ.NUM'
RETURN

*----------------------------------------------------------------------------------
OPEN.FILES:
*----------------------------------------------------------------------------------
* Opening Files

    FN.REDO.FOREX.SEQ.NUM = 'F.REDO.FOREX.SEQ.NUM'
    F.REDO.FOREX.SEQ.NUM = ''
    CALL OPF(FN.REDO.FOREX.SEQ.NUM,F.REDO.FOREX.SEQ.NUM)

    FN.LOCKING='F.LOCKING'

RETURN

*----------------------------------------------------------------------------------
PROCESS:
*----------------------------------------------------------------------------------
* Updating the FXSN table with records

    REQ.NUMS = R.NEW(UP.FX.SPECIFY.NO.REC)

    R.LOCKING.REC = ""
    LOCK.ERR = ""
    CALL F.READ(FN.LOCKING,LOCK.ID,R.LOCKING.REC,F.LOCKING,LOCK.ERR)
    VAR.CONTENT = ''

    IF R.LOCKING.REC EQ "" THEN
        R.LOCKING.REC<EB.LOK.CONTENT> = "0000000000"
    END
    VAR.CONTENT = R.LOCKING.REC<EB.LOK.CONTENT>

    LOOP
    WHILE REQ.NUMS NE 0
        VAR.CONTENT += 1 ;*R22 AUTO CONVERSION
        FXSN.ID = VAR.CONTENT
        FXSN.ID = FMT(FXSN.ID,'R%10')
        GOSUB UPDATE.FXSN.TXN.DETAILS
        REQ.NUMS -= 1 ;*R22 AUTO CONVERSION
    REPEAT

    R.LOCKING.REC<EB.LOK.CONTENT> = FXSN.ID
    CALL F.WRITE(FN.LOCKING,LOCK.ID,R.LOCKING.REC)
    CALL JOURNAL.UPDATE('')
RETURN

*----------------------------------------------------------------------------------
GET.TIME.NOW:
*----------------------------------------------------------------------------------
    SYS.TIME.NOW = OCONV(DATE(),"D-")
    SYS.TIME.NOW = SYS.TIME.NOW[9,2]:SYS.TIME.NOW[1,2]:SYS.TIME.NOW[4,2]
    SYS.TIME.NOW := TIMEDATE()[1,2]:TIMEDATE()[4,2]
RETURN

*----------------------------------------------------------------------------------
UPDATE.FXSN.TXN.DETAILS:
*----------------------------------------------------------------------------------
    R.FXSN.ARR = ''
    GOSUB GET.TIME.NOW
    R.FXSN.ARR<REDO.FXSN.FX.SEQ.STATUS> = 'AVAILABLE'
    R.FXSN.ARR<REDO.FXSN.MANUAL.UPDATE> = 'NO'
    R.FXSN.ARR<REDO.FXSN.CURR.NO> = '1'
    R.FXSN.ARR<REDO.FXSN.INPUTTER> = C$T24.SESSION.NO:"_":OPERATOR ;*R22 AUTO CONVERSION
    R.FXSN.ARR<REDO.FXSN.DATE.TIME> = SYS.TIME.NOW
    R.FXSN.ARR<REDO.FXSN.AUTHORISER> = C$T24.SESSION.NO:"_":OPERATOR ;*R22 AUTO CONVERSION
    R.FXSN.ARR<REDO.FXSN.CO.CODE> = ID.COMPANY
    R.FXSN.ARR<REDO.FXSN.DEPT.CODE> = R.USER<EB.USE.DEPARTMENT.CODE>
    CALL F.WRITE(FN.REDO.FOREX.SEQ.NUM,FXSN.ID,R.FXSN.ARR)
RETURN

END
