* @ValidationCode : MjoxODM5OTIwNzc4OkNwMTI1MjoxNjgxMTIxODExODcyOnNhbWFyOi0xOi0xOjA6MDpmYWxzZTpOL0E6REVWXzIwMjEwOC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 10 Apr 2023 15:46:51
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : samar
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.V.AUTH.UPD.ADDRESS
*******************************************************************************************************************

*Company   Name    : ASOCIACISN POPULAR DE AHORROS Y PRISTAMOS
*Developed By      : TEMENOS APPLICATION MANAGEMENT
*Program   Name    : REDO.V.AUTH.UPD.ADDRESS

*------------------------------------------------------------------------------------------------------------------
*Description       : A SERIES OF LOCAL REFERENCE FIELDS ARE TO BE CREATED IN THE APPLICATIONS, CUSTOMER AND DE.ADDRESS
*                    THESE LOCAL REFERENCE FIELDS WOULD BE USED TO STORE THE COMPLETE ADDRESS FIELDS OF THE NEWLY CREATED CUSTOMER
*                    WHILE AUTHORISING THE CUSTOMER RECORD, SYSTEM SHOULD UPDATE THE DE.ADDRESS FIELDS
*------------------------------------------------------------------------------------------------------------------
* Revision History:
*------------------------------------------------------------------------------------------
*   Date               who           Reference            Description
* 26/03/2015         Senthil                          ADDRESS from Customer is changed to LOWER()
*------------------------------------------------------------------------------------------

*Modification History
*DATE                       WHO                         REFERENCE                                   DESCRIPTION
*10-04-2023            Conversion Tool             R22 Auto Code conversion                      FM TO @FM VM TO @VM
*10-04-2023              Samaran T                R22 Manual Code conversion                         No Changes
*--------------------------------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER
    $INSERT I_F.DE.ADDRESS

    GOSUB INIT
    GOSUB OPENFILES
    GOSUB PROCESS
*------------
INIT:
*------------
    FN.DE.ADD = 'F.DE.ADDRESS'
    F.DE.ADD = ''
    SEL.CMD = ''
    SEL.LIST = ''
    LOCAL.REF.POS=''
    LOCAL.REF.POS1=''

RETURN
*------------
OPENFILES:
*------------
    CALL OPF(FN.DE.ADD,F.DE.ADD)

RETURN
*------------
PROCESS:
*------------


*USING THE CORE SUBROUTINE, MULTI.GET.LOC.REF, FOR THE CUSTOMER APPLICATION,
*GET THE LOCAL REFERENCE FIELD POSITIONS FOR THE FIELDS,
*L.CU.RES.SECTOR AND L.CU.URB.ENS.RES
*USING THE CORE SUBROUTINE, MULTI.GET.LOC.REF, FOR THE DE.ADDRESS APPLICATION,
*GET THE LOCAL REFERENCE FIELD POSITIONS FOR THE FIELDS,
*L.DA.TIPO.RES, L.DA.PAIS, L.CU.RES.SECTOR, L.CU.URB.ENS.RES, L.DA.NO.DIR, L.DA.APT.POSTAL

    LREF.APP = 'CUSTOMER':@FM:'DE.ADDRESS'
    LREF.FIELDS = 'L.CU.RES.SECTOR':@VM:'L.CU.URB.ENS.RE':@FM:'L.DA.TIPO.RES':@VM:'L.DA.PAIS':@VM:'L.CU.RES.SECTOR':@VM:'L.CU.URB.ENS.RE':@VM:'L.DA.NO.DIR':@VM:'L.DA.APT.POSTAL'
    CALL MULTI.GET.LOC.REF(LREF.APP,LREF.FIELDS,LOCAL.REF.POS)
    L.CU.RES.SECTOR.POS = LOCAL.REF.POS<1,1>
    L.CU.URB.ENS.RES.POS = LOCAL.REF.POS<1,2>

    L.DA.TIPO.RES.POS = LOCAL.REF.POS<2,1>
    L.DA.PAIS.POS = LOCAL.REF.POS<2,2>
    L.DA.RES.SECTOR.POS = LOCAL.REF.POS<2,3>
    L.DA.URB.ENS.RES.POS = LOCAL.REF.POS<2,4>
    L.DA.NO.DIR.POS = LOCAL.REF.POS<2,5>
    L.DA.APT.POSTAL.POS = LOCAL.REF.POS<2,6>

*USING THE FRAMED ID, READ THE APPLICATION, DE.ADDRESS
*IF THE RECORD IS EXISTING, THEN UPDATE THE FIELDS OF THE DE.ADDRESS WITH THE CUSTOMER APPLICATION FIELDS
*OTHERWISE WRITE THE RECORD OF DE.ADDRESS
    FRAME.ID = ID.COMPANY:'.C-':ID.NEW:'.PRINT.1'
    CALL F.READ(FN.DE.ADD,FRAME.ID,R.DE.ADDRESS,F.DE.ADD,DE.ADD.ERR1)
    IF R.DE.ADDRESS THEN
        R.DE.ADDRESS<DE.ADD.LOCAL.REF,L.DA.TIPO.RES.POS> = R.NEW(EB.CUS.RESIDENCE.TYPE)
        R.DE.ADDRESS<DE.ADD.LOCAL.REF,L.DA.PAIS.POS> = R.NEW(EB.CUS.RESIDENCE)
        R.DE.ADDRESS<DE.ADD.TOWN.COUNTY> = R.NEW(EB.CUS.TOWN.COUNTRY)
        R.DE.ADDRESS<DE.ADD.COUNTRY> = R.NEW(EB.CUS.COUNTRY)
        R.DE.ADDRESS<DE.ADD.LOCAL.REF,L.DA.RES.SECTOR.POS> = R.NEW(EB.CUS.LOCAL.REF)<1,L.CU.RES.SECTOR.POS>
        R.DE.ADDRESS<DE.ADD.LOCAL.REF,L.DA.URB.ENS.RES.POS> = R.NEW(EB.CUS.LOCAL.REF)<1,L.CU.URB.ENS.RES.POS>
        R.DE.ADDRESS<DE.ADD.STREET.ADDRESS> = R.NEW(EB.CUS.STREET)
        R.DE.ADDRESS<DE.ADD.LOCAL.REF,L.DA.NO.DIR.POS> = LOWER(R.NEW(EB.CUS.ADDRESS))         ;*Changes for Migration issue
        R.DE.ADDRESS<DE.ADD.LOCAL.REF,L.DA.APT.POSTAL.POS> = R.NEW(EB.CUS.OFF.PHONE)
        R.DE.ADDRESS<DE.ADD.POST.CODE> = R.NEW(EB.CUS.POST.CODE)


    END ELSE

        R.DE.ADDRESS<DE.ADD.LOCAL.REF,L.DA.TIPO.RES.POS> = R.NEW(EB.CUS.RESIDENCE.TYPE)
        R.DE.ADDRESS<DE.ADD.LOCAL.REF,L.DA.PAIS.POS> = R.NEW(EB.CUS.RESIDENCE)
        R.DE.ADDRESS<DE.ADD.TOWN.COUNTY> = R.NEW(EB.CUS.TOWN.COUNTRY)
        R.DE.ADDRESS<DE.ADD.COUNTRY> = R.NEW(EB.CUS.COUNTRY)
        R.DE.ADDRESS<DE.ADD.LOCAL.REF,L.DA.RES.SECTOR.POS> = R.NEW(EB.CUS.LOCAL.REF)<1,L.CU.RES.SECTOR.POS>
        R.DE.ADDRESS<DE.ADD.LOCAL.REF,L.DA.URB.ENS.RES.POS> = R.NEW(EB.CUS.LOCAL.REF)<1,L.CU.URB.ENS.RES.POS>
        R.DE.ADDRESS<DE.ADD.STREET.ADDRESS> = R.NEW(EB.CUS.STREET)
        R.DE.ADDRESS<DE.ADD.LOCAL.REF,L.DA.NO.DIR.POS> = LOWER(R.NEW(EB.CUS.ADDRESS))         ;* Changes for Migration issue
        R.DE.ADDRESS<DE.ADD.LOCAL.REF,L.DA.APT.POSTAL.POS> = R.NEW(EB.CUS.OFF.PHONE)
        R.DE.ADDRESS<DE.ADD.POST.CODE> = R.NEW(EB.CUS.POST.CODE)

    END
    CALL F.WRITE(FN.DE.ADD,FRAME.ID,R.DE.ADDRESS)
RETURN
END
