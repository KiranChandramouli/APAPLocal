* @ValidationCode : MjoxMDg3OTcyMTc1OkNwMTI1MjoxNjgwNzgzNjY1NjczOklUU1M6LTE6LTE6NjM6MTpmYWxzZTpOL0E6REVWXzIwMjEwOC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 06 Apr 2023 17:51:05
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 63
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOFCFI
SUBROUTINE REDO.FC.NOF.ENQ.DOC.LOAN(DATA.OUT)
*
* ====================================================================================
*
*
* ====================================================================================
*
* Subroutine Type :Routine to  Nofile Enquiry
* Attached to     :REDO.FC.TYPE.DOC ENQUIRY
* Attached as     :Build routine attach to PRODUCT field in REDO.FC.TYPE.DOC ENQUIRY enquiry
* Primary Purpose :Put de Type of the Product of REDO.LOAN.DOCUMENTATION  in O.DATA to enquiry
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
* Modification History:
*
* Development for : Asociacion Popular de Ahorros y Prestamos
* Development by  : Bryan Torres (btorresalbornoz@temenos.com) - TAM Latin America
* Date            : Agosto 26 2011
* Modification History:
* Date                 Who                              Reference                            DESCRIPTION
*04-04-2023           CONVERSION TOOL                AUTO R22 CODE CONVERSION                 NO CHANGES
*04-04-2023          jayasurya H                       MANUAL R22 CODE CONVERSION            NO CHANGES
*=======================================================================

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.REDO.CREATE.ARRANGEMENT
    $INSERT I_F.REDO.LOAN.DOCUMENTATION


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

    LOCATE "PRODUCT" IN D.FIELDS<1> SETTING PRO.POS THEN
        Y.PRODUCT=D.RANGE.AND.VALUE<PRO.POS>
    END

    SELECT.STATEMENT = 'SELECT ':FN.REDO.LOAN.DOCUMENTATION
    Y.REDO.LOAN.LIST = ''
    LIST.NAME = ''
    SELECTED = ''
    SYSTEM.RETURN.CODE = ''
    Y.TYPE.PRODUCT = ''

    CALL EB.READLIST(SELECT.STATEMENT,Y.REDO.LOAN.LIST,LIST.NAME,SELECTED,SYSTEM.RETURN.CODE)
    LOOP
        REMOVE Y.TYPE.PRODUCT FROM Y.REDO.LOAN.LIST SETTING POS
    WHILE Y.TYPE.PRODUCT:POS
        CALL CACHE.READ(FN.REDO.LOAN.DOCUMENTATION, Y.TYPE.PRODUCT, R.REDO.LOAN.DOCUMENTATION, Y.ERR)
        IF R.REDO.LOAN.DOCUMENTATION THEN
            Y.TYPE.PRODUCT.LOAN.DOC = R.REDO.LOAN.DOCUMENTATION<LN.DOC.PRODUCT>
            Y.TYPE.PRODUCT.DESCRIPT=  R.REDO.LOAN.DOCUMENTATION<LN.DOC.NAME.DOC>
            LOCATE Y.PRODUCT IN Y.TYPE.PRODUCT.LOAN.DOC<1,1> SETTING PRODUCT.POS THEN
                DATA.OUT<-1>=Y.TYPE.PRODUCT:"*":Y.TYPE.PRODUCT.DESCRIPT
            END

        END

    REPEAT


RETURN
*
* =========
OPEN.FILES:
* =========
*
    CALL OPF(FN.REDO.LOAN.DOCUMENTATION,F.REDO.LOAN.DOCUMENTATION)
RETURN
*
* =========
INITIALISE:
* =========
*
    LOOP.CNT = 1
    MAX.LOOPS = 1
    PROCESS.GOAHEAD = 1

    FN.REDO.LOAN.DOCUMENTATION="F.REDO.LOAN.DOCUMENTATION"
    F.REDO.LOAN.DOCUMENTATION=""

RETURN

* ======================
CHECK.PRELIM.CONDITIONS:
* ======================
*

*
RETURN
*


END
