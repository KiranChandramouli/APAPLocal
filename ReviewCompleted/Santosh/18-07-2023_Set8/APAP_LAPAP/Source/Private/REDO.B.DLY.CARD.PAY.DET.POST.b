$PACKAGE APAP.LAPAP
SUBROUTINE REDO.B.DLY.CARD.PAY.DET.POST

*******************************************************************************************
* Description: The REPORT to capture the vision plus transaction posted on last working day.
* Dev By:V.P.Ashokkumar
*
*******************************************************************************************
*Modification History
*DATE                WHO                         REFERENCE                DESCRIPTION
*13-07-2023       Conversion Tool        R22 Auto Code conversion          INSERT FILE MODIFIED,FM TO @FM
*13-07-2023       Samaran T               R22 Manual Code Conversion       No Changes
*--------------------------------------------------------------------------------------------

    $INSERT I_COMMON  ;*R22 AUTO CODE CONVERSION.START
    $INSERT I_EQUATE
    $INSERT I_F.DATES
    $INSERT I_F.REDO.H.REPORTS.PARAM
    $INSERT I_REDO.B.DLY.CARD.PAY.DET.COMMON ;*R22 AUTO CODE CONVERSION.END

    GOSUB INIT.VAR
    GOSUB PROCESS
RETURN

INIT.VAR:
*********
    R.REDO.H.REPORTS.PARAM = ''; Y.PARAM.ERR = ''; F.CHK.DIR = ''; FINAL.ARRAY.ZRO = ''
    SEL.CMD = ''; SEL.LIST =''; NO.OF.REC = ''; RET.CODE = ''
    FN.REDO.H.REPORTS.PARAM = 'F.REDO.H.REPORTS.PARAM'; F.REDO.H.REPORTS.PARAM = ''
    FN.DR.OPER.VPLUS.WORKFILE = 'F.DR.OPER.VPLUS.WORKFILE'; F.DR.OPER.VPLUS.WORKFILE = ''
    CALL OPF(FN.REDO.H.REPORTS.PARAM,F.REDO.H.REPORTS.PARAM)
    CALL OPF(FN.DR.OPER.VPLUS.WORKFILE,F.DR.OPER.VPLUS.WORKFILE)

    Y.PARAM.ID = 'REDO.VPLUS'
    CALL CACHE.READ(FN.REDO.H.REPORTS.PARAM,Y.PARAM.ID,R.REDO.H.REPORTS.PARAM,Y.PARAM.ERR)
    IF R.REDO.H.REPORTS.PARAM THEN
        FN.CHK.DIR = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.OUT.DIR>
        YFILE.NAME = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.OUT.FILE.NAME>
    END
    CALL OPF(FN.CHK.DIR,F.CHK.DIR)
    R.FIL = ''; READ.FIL.ERR = ''
    CALL F.READ(FN.CHK.DIR,YFILE.NAME,R.FIL,F.CHK.DIR,READ.FIL.ERR)
    IF R.FIL THEN
        DELETE F.CHK.DIR,YFILE.NAME
    END
RETURN

PROCESS:
********
    FINAL.ARRAY.ZRO = "Numero de Tarjeta,Numero de Cuenta,Moneda,Monto del Pago,No. Autorizacion,Susursal / Canal,Fecha de transaccion,Hora de transaccion,Numero referencia,Numero cajero,Tipo de pago"
    SEL.CMD = "SSELECT ":FN.DR.OPER.VPLUS.WORKFILE
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,RET.CODE)
    LOOP
        REMOVE Y.TEMP.ID FROM SEL.LIST SETTING TEMP.POS
    WHILE Y.TEMP.ID:TEMP.POS
        R.DR.OPER.VPLUS.WORKFILE = ''; TEMP.ERR = ''
        CALL F.READ(FN.DR.OPER.VPLUS.WORKFILE,Y.TEMP.ID,R.DR.OPER.VPLUS.WORKFILE,F.DR.OPER.VPLUS.WORKFILE,TEMP.ERR)
        IF R.DR.OPER.VPLUS.WORKFILE THEN
            FINAL.ARRAY.ZRO<-1> = R.DR.OPER.VPLUS.WORKFILE
        END
    REPEAT

    CHANGE @FM TO CHARX(13):CHARX(10) IN FINAL.ARRAY.ZRO ;*R22 AUTO CODE CONVERSION
    WRITE FINAL.ARRAY.ZRO ON F.CHK.DIR, YFILE.NAME ON ERROR
        Y.ERR.MSG = "Unable to Write '":F.CHK.DIR:"'"
    END
RETURN

END
