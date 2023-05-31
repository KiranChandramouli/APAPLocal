* @ValidationCode : MjoxMTMyODk5NTQ0OlVURi04OjE2ODU1MjYzNDgwNjE6QWRtaW46LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 31 May 2023 15:15:48
* @ValidationInfo : Encoding          : UTF-8
* @ValidationInfo : User Name         : Admin
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOFCFI
******************************************************************************
SUBROUTINE REDO.FC.CL.VALIDATE
******************************************************************************
* Company Name:   Asociacion Popular de Ahorro y Prestamo (APAP)
* Developed By:   Reginal Temenos Application Management
*-----------------------------------------------------------------------------
* Subroutine Type :  VERSION ROUTINE
* Attached to     :  COLLATERAL.RIGHT,APAP.MANTENIMIENTO
* Attached as     :  Input Routine
* Primary Purpose :  Maintenance tasks when updating COLLATERAL.RIGHT info in secured loans
*-----------------------------------------------------------------------------
* Developer    : Luis Fernando Pazmino (lpazminodiaz@temenos.com)
* Date         : 15.06.2011
* Description  : Validates COLLATERAL/COLLATERAL.RIGHT data
*-----------------------------------------------------------------------------
* Modification History:
*
* Version   Date            Who               Reference      Description
* 1.0       08.08.2011      lpazmino          CR.180         Initial Version
* 04-APRIL-2023      Conversion Tool       R22 Auto Conversion - No changes
* 04-APRIL-2023      Harsha                R22 Manual Conversion - Added APAP.REDOFCFI to CALL
*------------------------------------------------------------------------
*-----------------------------------------------------------------------------
* Input/Output: NA
* Dependencies: NA
*-----------------------------------------------------------------------------

* <region name="INCLUDES">
    $INSERT I_COMMON
    $INSERT I_EQUATE

    $INSERT I_F.COLLATERAL.RIGHT

    $INSERT I_F.REDO.FC.CL.BALANCE
* </region>

    GOSUB INIT
    GOSUB OPEN.FILES
    GOSUB PROCESS

RETURN

* <region name="INIT" description="Initialize variables">
INIT:
    FN.COLLATERAL = 'F.COLLATERAL'
    F.COLLATERAL = ''

    FN.REDO.FC.LIMIT.AA = 'F.REDO.FC.LIMIT.AA'
    F.REDO.FC.LIMIT.AA = ''
    R.REDO.FC.LIMIT.AA = ''

    FN.REDO.FC.CL.BALANCE = 'F.REDO.FC.CL.BALANCE'
    F.REDO.FC.CL.BALANCE = ''
    R.REDO.FC.CL.BALANCE = ''

    Y.ERR = ''

    Y.CL.RIGHTS = ''
    Y.CR.NUM = ''

RETURN
* </region>

* <region name="OPEN.FILES" description="Open Files">
OPEN.FILES:
    CALL OPF(FN.COLLATERAL,F.COLLATERAL)
    CALL OPF(FN.REDO.FC.LIMIT.AA,F.REDO.FC.LIMIT.AA)
    CALL OPF(FN.REDO.FC.CL.BALANCE,F.REDO.FC.CL.BALANCE)

RETURN
* </region>

* <region name="PROCESS" description="Main Process">
PROCESS:

    GOSUB VALIDATE.CR.CL
    GOSUB VALIDATE.CR.MAINT

RETURN
* </region>

* <region name="VALIDATE.CR.CL" description="Validate Collateral Right - Collateral">
VALIDATE.CR.CL:
    Y.CR.ID = ID.NEW
    SELECT.STATEMENT = 'SELECT ' : FN.COLLATERAL : ' LIKE ' : Y.CR.ID : '....'

    COLLATERAL.LIST = ''
    LIST.NAME = ''
    SELECTED = ''
    SYSTEM.RETURN.CODE = ''

    CALL EB.READLIST(SELECT.STATEMENT,COLLATERAL.LIST,LIST.NAME,SELECTED,SYSTEM.RETURN.CODE)

    IF SELECTED GT 1 THEN
        AF = COLL.RIGHT.COLLATERAL.CODE
        ETEXT = 'EB-FC-CR-CL-NOT-ALLOWED'
        CALL STORE.END.ERROR
    END

RETURN
* </region>

* <region name="VALIDATE.CR.MAINT" description="Validate Collateral Right - Collateral">
* Esta validacion tiene 2 propositos:
*  - Cuando se quita el LIMIT.REFERENCE verifica que el prestamo no quede desprovisto de cobertura
*  - Cuando se aumenta el LIMIT.REFERENCE asocia la garantia a un prestamo (solo en redistribucion del saldos)
VALIDATE.CR.MAINT:
    Y.OLD.LIMIT.REF = R.OLD(COLL.RIGHT.LIMIT.REFERENCE)
    Y.NEW.LIMIT.REF = R.NEW(COLL.RIGHT.LIMIT.REFERENCE)

    IF Y.OLD.LIMIT.REF NE '' AND Y.NEW.LIMIT.REF EQ '' THEN
* Deasociando Garantia de Prestamo
        
        APAP.REDOFCFI.redoFcClProcess('MANTENIMIENTO');*R22 Manual Conversion - Added APAP.REDOFCFI
        
    END

RETURN
* </region>

END
