* @ValidationCode : MjoxNTgyODYwMzQ6Q3AxMjUyOjE2ODE4MjgwMDU5NzQ6SVRTUzotMTotMTo4MjoxOmZhbHNlOk4vQTpERVZfMjAyMTA4LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 18 Apr 2023 19:56:45
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 82
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDORETAIL
SUBROUTINE REDO.CARD.REORDER.ID.CHK
*--------------------------------------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.CARD.REORDER.ID.CHK
*--------------------------------------------------------------------------------------------------------
*Description  : This is a ID routine to Automatically populate ID
*Linked With  : REDO.CARD.REORDER.DEST
*In Parameter : N/A
*Out Parameter: N/A
*--------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*    Date            Who                  Reference               Description
*   ------         ------               -------------            -------------
* 1 DEC 2010    SWAMINATHAN       ODR-2010-03-0400        Initial Creation
* 14 NOV 2011   KAVITHA           PACS00152062            PACS00152062 FIX
* Modification History:
* Date                 Who                              Reference                            DESCRIPTION
*11-04-2023           CONVERSION TOOL                AUTO R22 CODE CONVERSION                 FREAD TO CACHEREAD
*11-04-2023          jayasurya H                       MANUAL R22 CODE CONVERSION            NO CHANGES
*--------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_F.COMPANY
    $INSERT I_F.USER



    IF V$FUNCTION EQ 'I' THEN
        GOSUB INIT

        GOSUB PROCESS
    END
RETURN
*-----------------------------------------------------------------------------------------------------------
INIT:
******

    FN.COMPANY = 'F.COMPANY'
    F.COMPANY = ''
    CALL OPF(FN.COMPANY,F.COMPANY)

    Y.VAL = COMI
    FINAL.COMP = R.COMPANY(EB.COM.FINANCIAL.COM)

RETURN
*-----------------------------------------------------------------------------------------------------------
PROCESS:
*********

    CALL CACHE.READ(FN.COMPANY, Y.VAL, R.COMP, Y.ERR.COMP) ;*AUTO R22 CODE CONVERSION
    IF R.COMP EQ '' THEN
        IF Y.VAL EQ 'ID' THEN
            COMI = ID.COMPANY
        END
    END ELSE
        IF ID.COMPANY EQ FINAL.COMP THEN
            COMI = Y.VAL
        END ELSE
            IF Y.VAL EQ ID.COMPANY THEN
                COMI = ID.COMPANY
            END ELSE
                E = "EB-CANNOT.ACCESS.COMPANY"
            END
        END
    END
*PACS00152062 -S
    LOCATE COMI IN R.USER<EB.USE.COMPANY.CODE,1> SETTING POS.ID ELSE
        IF R.USER<EB.USE.COMPANY.CODE,1> NE 'ALL' THEN
            E = "EB-CANNOT.ACCESS.COMPANY"
        END
    END
*PACS00152062-E

RETURN
*-----------------------------------------------------------------------------------------------------------
END
