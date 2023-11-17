* @ValidationCode : MjoxNDEzNDQyNDc1OkNwMTI1MjoxNjgxMTkzOTMzOTQyOklUU1M6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 11 Apr 2023 11:48:53
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.VP.B.CUSTOMER.SYNC.LOAD
*-----------------------------------------------------------------------------
* Developer    : Luis Fernando Pazmino (lpazminodiaz@temenos.com)
*                TAM Latin America
* Client       : Asociacion Popular de Ahorro & Prestamo (APAP)
* Date         : 04.30.2013
* Description  : Routine for sychronizing customers with Vision Plus
* Type         : Batch Routine
* Attached to  : BATCH > BNK/REDO.VP.CUST.SYNC.SERVICE
* Dependencies : NA
*-----------------------------------------------------------------------------
* Modification History:
*
* Version   Date           Who            Reference         Description
* 1.0       04.30.2013     lpazmino       -                 Initial Version
* 2.0       2-sep-2015     Prabhu                           modified to multi thread
*           11.04.2023     Conversion Tool   R22            Auto Conversion     - No changes
*           11.04.2023     Shanmugapriya M   R22            Manual Conversion   - No changes
*
*-----------------------------------------------------------------------------

* <region name="INSERTS">

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER
    $INSERT I_F.REDO.VISION.PLUS.PARAM
    $INSERT I_REDO.VP.B.CUSTOMER.SYNC.COMMON
* </region>

    GOSUB INIT
    GOSUB OPEN.FILES

RETURN


***********************
INIT:
***********************

    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER  = ''

    APPL        = 'CUSTOMER'
    FLD         = 'L.CU.TARJ.CR'
    POS         = ''
    CALL MULTI.GET.LOC.REF (APPL, FLD, POS)
    CU.TARJ.CR.POS = POS<1,1>
    PROCESS.DATE = TRIM(TODAY,' ','B')

    FN.REDO.VISION.PLUS.PARAM = 'F.REDO.VISION.PLUS.PARAM'
    F.REDO.VISION.PLUS.PARAM  = ''
    REDO.VISION.PLUS.PARAM.ID = 'SYSTEM'

    CALL CACHE.READ(FN.REDO.VISION.PLUS.PARAM, REDO.VISION.PLUS.PARAM.ID, R.REDO.VISION.PLUS.PARAM, Y.ERR)

    CS.PATH = TRIM(R.REDO.VISION.PLUS.PARAM<VP.PARAM.CS.FILE.PATH>,' ','B')
    CS.FILE = TRIM(R.REDO.VISION.PLUS.PARAM<VP.PARAM.CS.FILE.NAME>,' ','B')

    CS.FILE= EREPLACE(CS.FILE, "<YYYYMMDD>", PROCESS.DATE)

    OPEN CS.PATH TO Y.PTR ELSE

    END
RETURN

***********************
OPEN.FILES:
***********************

    CALL OPF(FN.CUSTOMER, F.CUSTOMER)
RETURN
END
