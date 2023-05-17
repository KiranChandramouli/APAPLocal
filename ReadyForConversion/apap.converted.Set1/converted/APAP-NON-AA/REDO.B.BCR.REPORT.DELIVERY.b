SUBROUTINE REDO.B.BCR.REPORT.DELIVERY
*-----------------------------------------------------------------------------
* Rutina de tipo JOB para ser invocada desde el COB. La funcionalidad de esta
* rutina es la entrega de los archivos planos asociados con la generaci�n autom�tica de archivos en la interface Buro de Cr�dito
* @author mgudino@temenos.com
* @stereotype subroutine
* @package TAM.BP
*!
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.INTERFACE.PARAM
*-----------------------------------------------------------------------------

    GOSUB INITIALISE
    IF Y.RID.LIST EQ "" THEN    ;* Nothing to do
        RETURN
    END

    GOSUB PROCESS

RETURN

*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
*CALL THE LOG PROCCESS FOR START
*01 � �Reporte de Actividad.� (Activity Report)
*02 � �Resultado del proceso de validaci�n.� (Result of validation process)
*03 � �Rechazos originados en T24.� (Rejections originated by T24)
*04 � �Ocurri� un error de contenido de informaci�n� (Error of Information Contents occurs)
*05 � �Alerta� (Warning)
*06 � �Inicio del Proceso.� (Start of Process, only for Batch Interfaces). *Internal Use Only
*07 � �Fin del Proceso.� (End of Process, only Batch Interfaces). *Internal Use Only
*08 � �Ocurri� un error inesperado. El sistema no pudo controlar la *excepci�n.� (Unexpected error ocurrs. System can�t manage the *exception)
*09 � �Informaci�n adicional necesaria.� (Additional Information Needed).*

*INITIALIZE THE VALUES TO MAKE THE LOG
    Y.NO.LIST = DCOUNT(Y.RID.LIST,@FM)
    Y.CONT = 0
    MON.TP = '06'
    ID.PROC = 0
    DESC = "Iniciando la lectura, tomando el primer registro de la lista."

    LOOP
        REMOVE Y.REDO.INT.PARAM.ID FROM Y.RID.LIST SETTING Y.POS
        CALL REDO.INTERFACE.REC.ACT(Y.REDO.INT.PARAM.ID,'BATCH',Y.CONT,Y.NO.LIST,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,OPERATOR,C$T24.SESSION.NO)
    WHILE Y.POS : Y.REDO.INT.PARAM.ID
        CALL F.READ(FN.REDO.INT.PARAM, Y.REDO.INT.PARAM.ID, R.REDO.INT.PARAM,F.REDO.INT.PARAM, Y.ERR)
        IF Y.ERR NE '' THEN
            TEXT = "ERROR AL PROCESAR BURO CREDITO " : Y.ERR
            CALL FATAL.ERROR('REDO.B.BCR.REPORT.BUILD' : Y.REDO.INT.PARAM.ID)
        END
        E = ''
        CALL REDO.R.BCR.REPORT.DELIVERY(Y.REDO.INT.PARAM.ID,'BATCH',R.REDO.INT.PARAM)

        IF E NE '' THEN
            MON.TP = '08'
            ID.PROC = Y.CONT
            DESC = E
            CALL REDO.INTERFACE.REC.ACT(Y.REDO.INT.PARAM.ID,'BATCH',Y.CONT,Y.NO.LIST,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,OPERATOR,C$T24.SESSION.NO)
        END
        Y.CONT += 1
    REPEAT
    MON.TP = '07'
    ID.PROC = Y.CONT
    DESC = "El proceso termino exitosamente."
    CALL REDO.INTERFACE.REC.ACT(Y.REDO.INT.PARAM.ID,'BATCH',Y.CONT,Y.NO.LIST,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,OPERATOR,C$T24.SESSION.NO)
RETURN

*-----------------------------------------------------------------------------
INITIALISE:
*-----------------------------------------------------------------------------

    Y.RID.LIST = ''   ;* List of the records into REDO.INTERFACE.PARAM to process
;* Check if there are some to process
    CALL REDO.R.BCR.REPORT.GEN.LIST.GET(Y.RID.LIST)
    IF Y.RID.LIST EQ "" THEN
        RETURN          ;* Process must not be continued
    END

    FN.REDO.INT.PARAM = 'F.REDO.INTERFACE.PARAM'
    F.REDO.INT.PARAM = ''
    CALL OPF(FN.REDO.INT.PARAM, F.REDO.INT.PARAM)


RETURN

END
