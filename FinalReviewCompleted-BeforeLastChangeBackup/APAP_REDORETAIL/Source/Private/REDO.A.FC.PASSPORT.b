* @ValidationCode : MjotMzgyNDEzMjI6Q3AxMjUyOjE2ODEyNzY1NTQyMDU6SVRTUzotMTotMTotMjI6MTpmYWxzZTpOL0E6REVWXzIwMjEwOC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 12 Apr 2023 10:45:54
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -22
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDORETAIL
SUBROUTINE REDO.A.FC.PASSPORT
*
* Subroutine Type : ROUTINE
* Attached to     : CUSTOMER module
* Attached as     : ROUTINE
* Primary Purpose : concatenate LEGAL.ID + NATIONALITY
*
* Incoming:
* ---------
*
*
* Outgoing:
* ---------
*
*
* Error Variables:
*
*-----------------------------------------------------------------------------------
* Modification History:
*
* Development for : Asociacion Popular de Ahorros y Prestamos
* Development by  : Juan Pablo Armas - TAM Latin America
* Date            :
* Fix by          : JP - This fix solve the HD1053754 issue
* Date fix        : 07 / 02 / 2011
* Date modify fix : 01 April 2011
* Modification History:
* Date                 Who                              Reference                            DESCRIPTION
*10-04-2023           CONVERSION TOOL                AUTO R22 CODE CONVERSION                 NO CHANGES
*10-04-2023          jayasurya H                       MANUAL R22 CODE CONVERSION            NO CHANGES

*-----------------------------------------------------------------------------------


    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER
    GOSUB INITIALISE
    GOSUB OPEN.FILES

    IF PROCESS.GOAHEAD THEN
        GOSUB PROCESS
    END
RETURN
*-----------------------------------------------------------------------------------
PROCESS:
*=======
    Y.FIELD.NAME = 'L.CU.PASS.NAT'
    Y.FIELD.NO = 0
    CALL GET.LOC.REF ('CUSTOMER',Y.FIELD.NAME,Y.FIELD.NO)
    IF R.NEW(EB.CUS.LEGAL.ID) THEN
        R.NEW(EB.CUS.LOCAL.REF)<1,Y.FIELD.NO> = R.NEW(EB.CUS.LEGAL.ID):"-":R.NEW(EB.CUS.NATIONALITY)
    END ELSE
        R.NEW(EB.CUS.LOCAL.REF)<1,Y.FIELD.NO> = ""
    END
RETURN

*------------------------
INITIALISE:
*=========
    PROCESS.GOAHEAD = 1

RETURN

*------------------------
OPEN.FILES:
*=========

RETURN
*-----------------------
END
