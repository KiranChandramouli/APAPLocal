* @ValidationCode : MjoxNDQyMDQxMjc3OkNwMTI1MjoxNjkwMjY0MzUyNjM1OklUU1MxOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIyX1NQNS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 25 Jul 2023 11:22:32
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R22_SP5.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.B.BCR.REPORT.DELIVERY
*-----------------------------------------------------------------------------
* Rutina de tipo JOB para ser invocada desde el COB. La funcionalidad de esta
* rutina es la entrega de los archivos planos asociados con la generaci�n autom�tica de archivos en la interface Buro de Cr�dito
* @author mgudino@temenos.com
* @stereotype subroutine
* @package TAM.BP
*!
*-------------------------------------------------------------------------------------
*Modification
* Date                   who                   Reference
* 10-04-2023         CONVERSTION TOOL     R22 AUTO CONVERSTION FM TO @FM AND ++ TO += 1 AND TNO TO C$T24.SESSION.NO
* 10-04-2023          ANIL KUMAR B        R22 MANUAL CONVERSTION -NO CHANGES
*--------------------------------------------------------------------------------------
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.INTERFACE.PARAM
    $USING APAP.REDOCHNLS
    $USING APAP.TAM
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
*       CALL REDO.INTERFACE.REC.ACT(Y.REDO.INT.PARAM.ID,'BATCH',Y.CONT,Y.NO.LIST,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,OPERATOR,C$T24.SESSION.NO) ;*R22 AUTO CONVERSTION TNO TO C$T24.SESSION.NO
        APAP.REDOCHNLS.redoInterfaceRecAct(Y.REDO.INT.PARAM.ID,'BATCH',Y.CONT,Y.NO.LIST,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,OPERATOR,C$T24.SESSION.NO) ;*R22 Manual Code Conversion
    WHILE Y.POS : Y.REDO.INT.PARAM.ID
        CALL F.READ(FN.REDO.INT.PARAM, Y.REDO.INT.PARAM.ID, R.REDO.INT.PARAM,F.REDO.INT.PARAM, Y.ERR)
        IF Y.ERR NE '' THEN
            TEXT = "ERROR AL PROCESAR BURO CREDITO " : Y.ERR
            CALL FATAL.ERROR('REDO.B.BCR.REPORT.BUILD' : Y.REDO.INT.PARAM.ID)
        END
        E = ''
*       CALL REDO.R.BCR.REPORT.DELIVERY(Y.REDO.INT.PARAM.ID,'BATCH',R.REDO.INT.PARAM)
        APAP.TAM.redoRBcrReportDelivery(Y.REDO.INT.PARAM.ID,'BATCH',R.REDO.INT.PARAM) ;*R22 Manual Code Conversion

        IF E NE '' THEN
            MON.TP = '08'
            ID.PROC = Y.CONT
            DESC = E
*         CALL REDO.INTERFACE.REC.ACT(Y.REDO.INT.PARAM.ID,'BATCH',Y.CONT,Y.NO.LIST,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,OPERATOR,C$T24.SESSION.NO) ;*R22 AUTO CONVERSTION TNO TO C$T24.SESSION.NO
            APAP.REDOCHNLS.redoInterfaceRecAct(Y.REDO.INT.PARAM.ID,'BATCH',Y.CONT,Y.NO.LIST,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,OPERATOR,C$T24.SESSION.NO) ;*R22 Manual Code Conversion
        END
        Y.CONT += 1
    REPEAT
    MON.TP = '07'
    ID.PROC = Y.CONT
    DESC = "El proceso termino exitosamente."
*   CALL REDO.INTERFACE.REC.ACT(Y.REDO.INT.PARAM.ID,'BATCH',Y.CONT,Y.NO.LIST,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,OPERATOR,C$T24.SESSION.NO)
    APAP.REDOCHNLS.redoInterfaceRecAct(Y.REDO.INT.PARAM.ID,'BATCH',Y.CONT,Y.NO.LIST,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,OPERATOR,C$T24.SESSION.NO) ;*R22 Manual Code Conversion
RETURN

*-----------------------------------------------------------------------------
INITIALISE:
*-----------------------------------------------------------------------------

    Y.RID.LIST = ''   ;* List of the records into REDO.INTERFACE.PARAM to process
;* Check if there are some to process
*   CALL REDO.R.BCR.REPORT.GEN.LIST.GET(Y.RID.LIST)
    APAP.TAM.redoRBcrReportGenListGet(Y.RID.LIST) ;*R22 Manual Code Conversion
    IF Y.RID.LIST EQ "" THEN
        RETURN          ;* Process must not be continued
    END

    FN.REDO.INT.PARAM = 'F.REDO.INTERFACE.PARAM'
    F.REDO.INT.PARAM = ''
    CALL OPF(FN.REDO.INT.PARAM, F.REDO.INT.PARAM)


RETURN

END
