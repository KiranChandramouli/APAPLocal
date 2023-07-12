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

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_TSA.COMMON
    $INSERT I_BATCH.FILES
    $INSERT I_F.EB.LOOKUP
    $INSERT I_F.AA.OVERDUE
    $INSERT I_REDO.APAP.NEW.CONDITION.RT.COMO

    Y.ARCHIVO.CARGA = "LOAD.CONDITION.txt"
*Limpiando tabla temporal
    CALL EB.CLEAR.FILE(FN.CONCATE.WRITE,FV.CONCATE.WRITE)

    R.CHK.DIR = "" ; CHK.DIR.ERROR = "";
    CALL F.READ(FN.CHK.DIR,Y.ARCHIVO.CARGA,R.CHK.DIR,F.CHK.DIR,CHK.DIR.ERROR)

    SEL.LIST = R.CHK.DIR;
    CALL BATCH.BUILD.LIST('',SEL.LIST)

RETURN


END
