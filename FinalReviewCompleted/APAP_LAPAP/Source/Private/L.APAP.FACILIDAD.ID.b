* @ValidationCode : Mjo2Mjg5MDkwNjI6Q3AxMjUyOjE2ODIzMzEzMjIzNTc6SVRTUzotMTotMToxODc6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 24 Apr 2023 15:45:22
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 187
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE L.APAP.FACILIDAD.ID

* Date         : 2021-12-06
* Description  : Setea un valor al campo L.CR.FACILITY en la tabla : F.REDO.CREATE.ARRANGEMENT
*                 dependiendo el tipo de producto campo PRODUCT basada en la tabla de parametro:REDO.H.REPORTS.PARAM
*                 registro LAPAP.FAC.TEMPLEATE
*               Se llama la rutina : REDO.FC.S.CL.OVERDS, del proveedor TEMENOS antes de aplicar la logica para no perder
*               la funcionalidad actual
*
*------------------------------------------------------------------------------------------------------------------
* Input/Output:
* -------------
* In  :
* Out :
*------------------------------------------------------------------------------------------------------------------
* Revision History:
* -----------------
* Version          Date          Name
* -------          ----          ----
* 1.1              2021-12-06    APAP
*------------------------------------------------------------------------------------------------------------------


*-----------------------------------------------------------------------------
*MODIFICATION HISTORY:
*
* DATE              WHO                REFERENCE                 DESCRIPTION
* 21-APR-2023     Conversion tool    R22 Auto conversion       BP Removed in insert file
* 21-APR-2023      Harishvikram C   Manual R22 conversion      No changes
*-----------------------------------------------------------------------------
    $INSERT I_COMMON ;*R22 Auto conversion - START
    $INSERT I_EQUATE
    $INSERT I_F.REDO.CREATE.ARRANGEMENT
    $INSERT I_F.REDO.H.REPORTS.PARAM ;*R22 Auto conversion - END



    Y.PRODUCTO = R.NEW(REDO.FC.PRODUCT)


**Y.PRODUCTO = 'CONS.CG.CTA.AHORRO2'
    GOSUB  TABLAS
    GOSUB LEER.TABLA.PARAMETROS

RETURN

TABLAS:
    FN.REDO.H.REPORTS.PARAM = "F.REDO.H.REPORTS.PARAM"
    F.REDO.H.REPORTS.PARAM  = ""
    CALL OPF(FN.REDO.H.REPORTS.PARAM,F.REDO.H.REPORTS.PARAM)


RETURN


LEER.TABLA.PARAMETROS:
    ID.REPORT = 'LAPAP.FAC.TEMPLEATE'
    CALL F.READ(FN.REDO.H.REPORTS.PARAM,ID.REPORT,R.REDO.H.REPORTS.PARAM,F.REDO.H.REPORTS.PARAM,ERROR.REPORT.PARAM)
    Y.FIELD.NME = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.NAME>
    Y.FIELD.VAL = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.VALUE>
    LOCATE Y.PRODUCTO IN Y.FIELD.NME<1,1> SETTING COD.POS THEN
        Y.FACILIDAD.ID = Y.FIELD.VAL<1,COD.POS>
*** Recibir un valor en un campo local
        CALL GET.LOC.REF("REDO.CREATE.ARRANGEMENT","L.CR.FACILITY",Y.L.CR.FACILITY.POS)
        R.NEW(REDO.FC.LOCAL.REF)<1,Y.L.CR.FACILITY.POS> =  Y.FACILIDAD.ID

***Colocar un campo local como no input
        T.LOCREF<Y.L.CR.FACILITY.POS,7> = "NOINPUT"
    END

RETURN


END
