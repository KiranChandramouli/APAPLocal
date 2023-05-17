SUBROUTINE REDO.FC.ENQ.AA.PRODUCT(ENQ.DATA)
*
* ====================================================================================
*

*
* ====================================================================================
*
* Subroutine Type :Build Routine
* Attached to     :REDO.FC.AA.PRODUCT ENQUIRY
* Attached as     :Build routine attach to  field in REDO.FC.AA.PRODUCT enquiry
* Primary Purpose :Put de Description of the product in O.DATA to enquiry
*
*
* Incoming:
* ---------
*
*
*
* Outgoing:

* ---------
*
*
*-----------------------------------------------------------------------------------
* Modification History:
*
* Development for : Asociacion Popular de Ahorros y Prestamos
* Development by  : Bryan Torres (btorresalbornoz@temenos.com) - TAM Latin America
* Date            : Agosto 23 2011
*=======================================================================



    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON

*
*************************************************************************
*

    GOSUB INITIALISE
    GOSUB OPEN.FILES
    GOSUB CHECK.PRELIM.CONDITIONS
    IF PROCESS.GOAHEAD THEN
        GOSUB PROCESS
    END

*
RETURN
*
* ======
PROCESS:

* ======



*LOCATE 'PRODUCT.GROUP' IN ENQ.DATA<2,1> SETTING POSSITION ELSE NULL
    ENQ.DATA<2,1>='PRODUCT.GROUP'

    ENQ.DATA<3,1>='EQ'

    ENQ.DATA<4,1>='CONSUMO HIPOTECARIO LINEAS.DE.CREDITO COMERCIAL'



RETURN


*
* =========
OPEN.FILES:
* =========
*

RETURN

* =========
INITIALISE:
* =========
*
    LOOP.CNT        = 1
    MAX.LOOPS       = 1
    PROCESS.GOAHEAD = 1

RETURN

* ======================
CHECK.PRELIM.CONDITIONS:
* ======================
*

*
RETURN
END
