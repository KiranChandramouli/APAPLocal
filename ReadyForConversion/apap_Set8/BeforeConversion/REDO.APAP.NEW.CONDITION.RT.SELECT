*-----------------------------------------------------------------------------
* <Rating>-1</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE REDO.APAP.NEW.CONDITION.RT.SELECT
*==============================================================================
* Esta rutina esta diceñada parara generar un archivo de cargar con nuavas
* nuevas condiciones para algunos prestamos para luego ser cargados por una DMT.
* DMT ===> APAP.UPDATE.CONDITION
*
* Modification History:
*
* Development for : Asociacion Popular de Ahorros y Prestamos
* Requerimiento   : ET-5281
* Development by  : Juan Pablo Garcia
* Date            : Dic. 29, 2020
*==============================================================================

    $INSERT T24.BP I_COMMON
    $INSERT T24.BP I_EQUATE
    $INSERT T24.BP I_TSA.COMMON
    $INSERT T24.BP I_BATCH.FILES
    $INSERT T24.BP I_F.EB.LOOKUP
    $INSERT T24.BP I_F.AA.OVERDUE
    $INSERT LAPAP.BP I_REDO.APAP.NEW.CONDITION.RT.COMO

    Y.ARCHIVO.CARGA = "LOAD.CONDITION.txt"
*Limpiando tabla temporal
    CALL EB.CLEAR.FILE(FN.CONCATE.WRITE,FV.CONCATE.WRITE)

    R.CHK.DIR = "" ; CHK.DIR.ERROR = "";
    CALL F.READ(FN.CHK.DIR,Y.ARCHIVO.CARGA,R.CHK.DIR,F.CHK.DIR,CHK.DIR.ERROR)

    SEL.LIST = R.CHK.DIR;
    CALL BATCH.BUILD.LIST('',SEL.LIST)

    RETURN


END
