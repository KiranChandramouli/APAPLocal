SUBROUTINE REDO.E.CONV.MAIL.ADD
*--------------------------------------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.E.CNV.REL.ADD
*--------------------------------------------------------------------------------------------------------
*Description  : REDO.E.CONV.MAIL.ADD is a converstion routine
*               This routine is used to build data for the Enquiry REDO.APAP.ACCT.STMT.TP
*In Parameter : N/A
*Out Parameter: N/A
*--------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*    Date            Who                     Reference               Description
* -----------    -------------             ----------------        ----------------
* 18 MAR 2011    SABARIKUMAR A             ODR-2010-08-0181        Initial Creation
*--------------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.ACCOUNT
    $INSERT I_F.COMPANY
    $INSERT I_F.CUSTOMER
    $INSERT I_F.DE.ADDRESS
    $INSERT I_F.DE.PRODUCT
    $INSERT I_F.COUNTRY

    GOSUB INITIALISE
    GOSUB OPENFILE
    GOSUB PROCESS
RETURN

*--------------------------------------------------------------------------------------------------------
INITIALISE:
*-------------
* Initailaise all the necessary variables

    Y.POS.DIR = ""
    Y.POS.URD = ""
    Y.POS.SEC = ""
    Y.POS.PAIS = ""
    Y.POS.POST = ""
    FN.ACCOUNT = 'F.ACCOUNT' ; F.ACCOUNT = ''
    FN.DE.PRODUCT = 'F.DE.PRODUCT' ; F.DE.PRODUCT=''
    FN.DE.ADDRESS='F.DE.ADDRESS'; F.DE.ADDRESS=''
    FN.CUSTOMER='F.CUSTOMER'; F.CUSTOMER=''
    FN.COUNTRY = 'F.COUNTRY'
    F.COUNTRY = ''
    Y.CARR = ''
RETURN

*--------------------------------------------------------------------------------------------------------
OPENFILE:
*------------
* Open all the necessary files

    CALL OPF(FN.ACCOUNT,F.ACCOUNT)
    CALL OPF(FN.DE.PRODUCT,F.DE.PRODUCT)
    CALL OPF(FN.DE.ADDRESS,F.DE.ADDRESS)
    CALL OPF(FN.COUNTRY,F.COUNTRY)
    Y.ACCT.NO=O.DATA
    O.DATA = ''
RETURN

*--------------------------------------------------------------------------------------------------------
PROCESS:
*------------
* Forms the value of O.DATA by fetching necessary values from DE.ADDRESS

    CALL F.READ(FN.ACCOUNT,Y.ACCT.NO,R.ACCOUNT.REC,F.ACCOUNT,ACCOUNT.ERR)
    Y.DEPT.NO=R.ACCOUNT.REC<AC.CO.CODE>
    Y.CUS.NO=R.ACCOUNT.REC<AC.CUSTOMER>
    Y.DE.ID=Y.DEPT.NO:'.A-':Y.ACCT.NO:'.ALL.ALL'
    CALL CACHE.READ(FN.DE.PRODUCT, Y.DE.ID, R.DE.PRODUCT.REC, DE.PRODUCT.ERR)
    Y.CARR = R.DE.PRODUCT.REC<DE.PRD.CARR.ADD.NO,1>
    IF R.DE.PRODUCT.REC NE '' THEN
        Y.DE.ADD.ID=R.ACCOUNT.REC<AC.CO.CODE>:'.C-':Y.CUS.NO:'.':Y.CARR
    END
    ELSE
        Y.DE.ADD.ID=R.ACCOUNT.REC<AC.CO.CODE>:'.C-':Y.CUS.NO:'.PRINT.1'
    END

    CALL F.READ(FN.DE.ADDRESS,Y.DE.ADD.ID,R.DE.ADDRESS.REC,F.DE.ADDRESS,DE.ADD.ERR)
    GOSUB GET.LT.DETS
    Y.DIR=R.DE.ADDRESS.REC<DE.ADD.LOCAL.REF,Y.POS.DIR>
    Y.URD=R.DE.ADDRESS.REC<DE.ADD.LOCAL.REF,Y.POS.URD>
    Y.SEC=R.DE.ADDRESS.REC<DE.ADD.LOCAL.REF,Y.POS.SEC>
    Y.PAIS=R.DE.ADDRESS.REC<DE.ADD.LOCAL.REF,Y.POS.PAIS>
    IF Y.PAIS NE '' THEN
        CALL CACHE.READ(FN.COUNTRY, Y.PAIS, R.COUNTRY, CTRY.ERR)
        Y.PAIS = R.COUNTRY<EB.COU.SHORT.NAME>
    END

    Y.POST=R.DE.ADDRESS.REC<DE.ADD.LOCAL.REF,Y.POS.POST>
    Y.TOWN.COUNTRY=R.DE.ADDRESS.REC<DE.ADD.TOWN.COUNTY>
    Y.COUNTRY=R.DE.ADDRESS.REC<DE.ADD.COUNTRY>
    Y.STR.ADR = R.DE.ADDRESS.REC<DE.ADD.STREET.ADDRESS>
*PACS00072406 -S
*   Y.DATA=TRIM(Y.STR.ADR):' ':TRIM(Y.DIR):" ":TRIM(Y.URD):" "
*   Y.DATA:=TRIM(Y.SEC):" ":TRIM(Y.COUNTRY):" ": TRIM(Y.TOWN.COUNTRY):" ":TRIM(Y.PAIS):" ":TRIM(Y.POST)
    Y.DATA = TRIM(Y.STR.ADR):' ':TRIM(Y.DIR)

    IF Y.STR.ADR NE '' OR Y.DIR NE '' THEN
        O.DATA=TRIM(Y.DATA)
*PACS00072406 -E
*END ELSE
*   O.DATA = "Not Applicable"
    END
RETURN

*--------------------------------------------------------------------------------------------------------
GET.LT.DETS:
*--------------
* Reads the core routine MULTI.GET.LOC.REF and gets the position of the required Local Fields

    APPL.NAME = 'DE.ADDRESS'
    FLD.NAME = 'L.DA.NO.DIR':@VM:'L.CU.URB.ENS.RE':@VM:'L.CU.RES.SECTOR':@VM:'L.DA.PAIS':@VM:'L.DA.APT.POSTAL'
    FLD.POS = ''
    CALL MULTI.GET.LOC.REF(APPL.NAME,FLD.NAME,FLD.POS)
    Y.POS.DIR = FLD.POS<1,1>
    Y.POS.URD = FLD.POS<1,2>
    Y.POS.SEC = FLD.POS<1,3>
    Y.POS.PAIS = FLD.POS<1,4>
    Y.POS.POST = FLD.POS<1,5>
RETURN

*--------------------------------------------------------------------------------------------------------
END
