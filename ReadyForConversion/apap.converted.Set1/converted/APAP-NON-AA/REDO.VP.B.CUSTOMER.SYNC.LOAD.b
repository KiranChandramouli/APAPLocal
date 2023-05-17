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
