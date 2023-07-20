$PACKAGE APAP.LAPAP
SUBROUTINE REDO.APAP.NEW.CONDITION.RT(Y.REGISTRO)
*==============================================================================
*==============================================================================
*Modification History
*DATE                       WHO                         REFERENCE                                   DESCRIPTION
*13-07-2023            Conversion Tool             R22 Auto Code conversion                FM TO @FM,VM TO @VM,SM TO @SM,INSERT FILE MODIFIED
*13-07-2023              Samaran T                R22 Manual Code conversion                         No Changes
*------------------------------------------------------------------------------------------------------------------------------------

    $INSERT I_COMMON  ;*R22 AUTO CODE CONVERSION.START
    $INSERT I_EQUATE
    $INSERT I_TSA.COMMON
    $INSERT I_F.EB.LOOKUP
    $INSERT I_F.AA.OVERDUE
    $INSERT I_REDO.APAP.NEW.CONDITION.RT.COMO  ;*R22 AUTO CODE CONVERSION.END

    Y.ACTIVIDAD = "LENDING-UPDATE-APAP.OVERDUE"
    Y.PROPERTY = "APAP.OVERDUE"
    Y.ARCHIVO.CARGA = "LOAD.CONDITION.txt"
    Y.FILE.LOAD.NAME = "AA.LIST.UPD"
    Y.CAMPO.COND = "L.LOAN.COND"
    Y.CAMPO.COMENT = "L.LOAN.COMMENT1"
    Y.FILE.FINAL = "AA.LIST.UPD"
    GOSUB PROCESS
RETURN



*==========*
PROCESS:  *Se cuentan los multivalores del campo L.LOAN.COND, para sumarle 1 y que de esta manera se agregue la nueva condicion.
*==========*

    Y.REGISTRO.POS = CHANGE(Y.REGISTRO,'|',@FM);  ;*R22 AUTO CODE CONVERSION

    Y.ARRANGEMENT.ID = Y.REGISTRO.POS<1>
    Y.CONDITION = Y.REGISTRO.POS<2>
    Y.COMENT = Y.REGISTRO.POS<3>

*CALL REDO.B.CON.LNS.BY.DEBTOR.AA.RECS(Y.ARRANGEMENT.ID,OUT.RECORD)
    GOSUB AA.OVERDUE.READ
*R.AA.OVERDUE = FIELD(OUT.RECORD,"*",5)

    CALL GET.LOC.REF("AA.PRD.DES.OVERDUE","L.LOAN.COND",OVERDUE.POS)
    Y.COND.FULL = R.AA.OVERDUE<AA.OD.LOCAL.REF,OVERDUE.POS>

    Y.COND.FULL = CHANGE(Y.COND.FULL,@SM,@FM)  ;*R22 AUTO CODE CONVERSION
    Y.COND.FULL = CHANGE(Y.COND.FULL,@VM,@FM)
    Y.CONT.COND = DCOUNT(Y.COND.FULL,@FM)  ;*R22 AUTO CODE CONVERSION
    Y.NUM.COND = Y.CONT.COND + 1

    GOSUB WRITE.FILE


RETURN

*---------------
AA.OVERDUE.READ:
**--------------
    ARRANGEMENT.ID = Y.ARRANGEMENT.ID
    R.AA.OVERDUE   = ''
    PROP.CLASS     = 'OVERDUE'
    PROP.NAME      = ''
    RET.ERR        = ''
    returnConditions = ''
    CALL AA.GET.ARRANGEMENT.CONDITIONS(ARRANGEMENT.ID,PROP.CLASS,PROP.NAME,'','',returnConditions,RET.ERR)
    R.AA.OVERDUE = RAISE(returnConditions)
    OVERDUE      = R.AA.OVERDUE
RETURN

*==========*
WRITE.FILE:         *Escribe el archivo de carga para la DMT
*==========*
    Y.FIELD.COND = Y.CAMPO.COND:":":Y.NUM.COND
    Y.FIELD.COMEN = Y.CAMPO.COMENT:":":Y.NUM.COND
    R.CONCATE.WRITE = Y.ARRANGEMENT.ID:"|":Y.ACTIVIDAD:"|":Y.PROPERTY:"|":Y.FIELD.COND:";;":Y.FIELD.COMEN:"|":Y.CONDITION:";;":Y.COMENT
    CALL F.WRITE(FN.CONCATE.WRITE,Y.ARRANGEMENT.ID,R.CONCATE.WRITE);

RETURN
END
