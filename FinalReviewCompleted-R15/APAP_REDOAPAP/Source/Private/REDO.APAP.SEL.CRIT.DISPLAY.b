* @ValidationCode : MjotMTIyNzc2MDc0ODpDcDEyNTI6MTY4NDgzNjA1MjkwMzpJVFNTOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 23 May 2023 15:30:52
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOAPAP
SUBROUTINE REDO.APAP.SEL.CRIT.DISPLAY
*--------------------------------------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.APAP.SEL.CRIT.DISPLAY
*--------------------------------------------------------------------------------------------------------
*Description  : REDO.APAP.SEL.CRIT.DISPLAY is the convertion Routine
*This routine is attached to Nofile Enquiry to Display the Selection Criteris Label & Values in Header Section
*In Parameter : N/A
*Out Parameter: N/A
*--------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*    Date            Who            ODR Reference      Description
*   ------         ------           -------------     ------------------
* 24 DEC 2010    Satish@Contractor  ODR-2011-03-0083  Initial Creation
* Date                  who                   Reference              
* 06-04-2023        �CONVERSTION TOOL   �  R22 AUTO CONVERSTION SM TO @SM
* 06-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES

*--------------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON

    SEL.VAL = FIELD(O.DATA,'#',1)
    SEL.LAB = FIELD(O.DATA,'#',2)

    Y.DATA = '';  SEL.CT = DCOUNT(SEL.LAB,'*')-1
    FOR II = 1 TO SEL.CT
        IF FIELD(SEL.VAL,'*',II) THEN
            Y.DATA:= FIELD(SEL.LAB,'*',II):' : ':FIELD(SEL.VAL,'*',II):' - '
        END
    NEXT II
    CHANGE @SM TO ' ' IN Y.DATA
    O.DATA = Y.DATA

RETURN

END
