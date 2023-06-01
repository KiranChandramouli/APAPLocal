* @ValidationCode : MjozNjEwMDIxMjM6Q3AxMjUyOjE2ODE5Nzk1OTc5OTU6SVRTUzotMTotMTotNjoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 20 Apr 2023 14:03:17
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -6
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOEB
SUBROUTINE REDO.EB.LOOKUP.LIST(Y.LOOKUP.ID,Y.LOOOKUP.VAL,Y.DESC.VAL,RES1,RES2)

*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :Pradeep S
*Program   Name    :REDO.EB.LOOKUP.LIST
*---------------------------------------------------------------------------------
*DESCRIPTION       : This routine will get the discription of EB.LOOKUP value
* ----------------------------------------------------------------------------------

*MODIFICATION HISTORY:
*
* DATE              WHO                REFERENCE                 DESCRIPTION
* 12-APR-2023     Conversion tool   R22 Auto conversion   FM TO @FM
* 12-APR-2023     Conversion tool    R22 Auto conversion       No changes
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.USER

    GOSUB PROCESS
RETURN

PROCESS:
**********

    VIRTUAL.TAB.ID = Y.LOOKUP.ID
    LOOKUP.VAL     = Y.LOOOKUP.VAL
    Y.DESC.VAL     = ''

    CALL EB.LOOKUP.LIST(VIRTUAL.TAB.ID)
    Y.LOOKUP.LIST=VIRTUAL.TAB.ID<2>
    Y.LOOKUP.DESC=VIRTUAL.TAB.ID<11>
    CHANGE '_' TO @FM IN Y.LOOKUP.LIST
    CHANGE '_' TO @FM IN Y.LOOKUP.DESC

    LOCATE LOOKUP.VAL IN Y.LOOKUP.LIST SETTING POS1 THEN
        Y.DESC.VAL = Y.LOOKUP.DESC<POS1,LNGG>
        IF Y.DESC.VAL EQ '' THEN
            Y.DESC.VAL = Y.LOOKUP.DESC<POS1,1>
        END
    END

RETURN
END
