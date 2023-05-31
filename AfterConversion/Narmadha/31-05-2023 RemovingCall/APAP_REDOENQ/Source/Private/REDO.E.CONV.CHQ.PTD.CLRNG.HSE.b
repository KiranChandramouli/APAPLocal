$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.E.CONV.CHQ.PTD.CLRNG.HSE

* Program Description
* Subroutine Type   : ENQUIRY ROUTINE
* Attached to       : REDO.APAP.CHQ.PTD.CLRNG.HSE.RPT
* Attached as       : CONVERSION  ROUTINE
* Primary Purpose   : To return data to the enquiry field

* Modification History :
* Development for : Asociacion Popular de Ahorros y Prestamos
* Development BY  : Madhu Chetan  - Contractor@TAM
* DATE            : Jan 11, 2011
*  DATE             WHO                   REFERENCE                  
* 11-APRIL-2023      Conversion Tool       R22 Auto Conversion - No changes
* 11-APRIL-2023      Harsha                R22 Manual Conversion - No changes                             
*------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.COMPANY

    Y.DATE.TIME = O.DATA
    Y.DATE = "20":O.DATA[1,6]
**  Y.REGION = R.COMPANY(EB.COM.LOCAL.COUNTRY):'00'
**  CALL CDT(Y.REGION,Y.DATE,'+1W')
    O.DATA = Y.DATE
RETURN
END
