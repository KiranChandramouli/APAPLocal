$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.E.CNV.PROD.CODE

****************************************************
*---------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By : JEEVA T
* Program Name : REDO.E.CNV.PROD.CODE
*---------------------------------------------------------

* Description : This subroutine is attached as a conversion routine to enquiry REDO.PLASTIC.CARD.BRANCH
* to calculate total no of card lost for the request

*----------------------------------------------------------
* Linked With : Enquiry REDO.E.CNV.COUNT.LOST
* In Parameter : None
* Out Parameter : None
*----------------------------------------------------------
* Modification History:
*----------------------------------------------------------
*
* 31-May-2010 - HD1021443
* This section of routine will remove entries, which has RELATION.CODE specified not in range from 1 to 299
*
* 02-Jun-2010 - HD1021443
* Modification made on referring to gosub WITH.RG.1.299.ONLY section for the ENQUIRY REDO.CUST.RELATION.VINC only
*6 JUN 2011 - PACS00024249
* Card typ read modification done
* 11-APRIL-2023      Conversion Tool       R22 Auto Conversion - No changes
* 11-APRIL-2023      Harsha                R22 Manual Conversion - No changes  
*----------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.CARD.TYPE
    $INSERT I_F.STOCK.ENTRY
    $INSERT I_F.REDO.CARD.SERIES.PARAM


    GOSUB OPEN.FILE
    GOSUB PROCESS
RETURN
*----------------------------------------------------------
OPEN.FILE:
*----------------------------------------------------------

    FN.CARD.TYPE = 'F.CARD.TYPE'
    F.CARD.TYPE = ''
    CALL OPF(FN.CARD.TYPE,F.CARD.TYPE)

    FN.REDO.CARD.SERIES.PARAM = 'F.REDO.CARD.SERIES.PARAM'
    F.REDO.CARD.SERIES.PARAM = ''
    CALL OPF(FN.REDO.CARD.SERIES.PARAM,F.REDO.CARD.SERIES.PARAM)

    FN.STOCK.ENTRY = 'F.STOCK.ENTRY'
    F.STOCK.ENTRY = ''
    CALL OPF(FN.STOCK.ENTRY,F.STOCK.ENTRY)

RETURN
*----------------------------------------------------------
PROCESS:
*----------------------------------------------------------
*PACS00024249-s
    Y.OUT = O.DATA

    LOC.REF.APPLICATION="CARD.TYPE"
    LOC.REF.FIELDS='L.CT.SUMIN.CO'
    LOC.REF.POS=''
    CALL MULTI.GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,LOC.REF.POS)
    POS.L.CO=LOC.REF.POS<1,1>

    CALL F.READ(FN.CARD.TYPE,Y.OUT,R.CARD.TYPE,F.CARD.TYPE,Y.CARD.TYPE.ERR)

    O.DATA = R.CARD.TYPE<CARD.TYPE.LOCAL.REF,POS.L.CO>

RETURN

*PACS00024249-e
END
