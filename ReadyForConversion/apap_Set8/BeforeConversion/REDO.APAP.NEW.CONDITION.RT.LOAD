*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE REDO.APAP.NEW.CONDITION.RT.LOAD
*==============================================================================
*==============================================================================

    $INSERT T24.BP I_COMMON
    $INSERT T24.BP I_EQUATE
    $INSERT T24.BP I_TSA.COMMON
    $INSERT T24.BP I_BATCH.FILES

    $INSERT T24.BP I_F.EB.LOOKUP
    $INSERT T24.BP I_F.AA.OVERDUE
    $INSERT LAPAP.BP I_REDO.APAP.NEW.CONDITION.RT.COMO

    Y.ACTIVIDAD = "LENDING-UPDATE-APAP.OVERDUE"
    Y.PROPERTY = "APAP.OVERDUE"
    Y.ARCHIVO.CARGA = "LOAD.CONDITION.txt"
    Y.FILE.LOAD.NAME = "AA.LIST.UPD"
    Y.CAMPO.COND = "L.LOAN.COND"
    Y.CAMPO.COMENT = "L.LOAN.COMMENT1"
    Y.FILE.FINAL = "AA.LIST.UPD"

    GOSUB OPEN.FILES
    RETURN

*==========*
OPEN.FILES:
*==========*
    FN.EB.LOOKUP = "F.EB.LOOKUP" ; FV.EB.LOOKUP = ""
    CALL OPF(FN.EB.LOOKUP,FV.EB.LOOKUP)

    FN.CHK.DIR = "DMFILES" ; F.CHK.DIR = ""
    CALL OPF(FN.CHK.DIR,F.CHK.DIR)
    FN.CONCATE.WRITE = "F.LAPAP.CONCATE.CONDIC"
    FV.CONCATE.WRITE = ""
    CALL OPF (FN.CONCATE.WRITE,FV.CONCATE.WRITE)


    RETURN

END
