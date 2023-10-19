$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.E.CNV.GET.PERIOD
*-------------------------------------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.E.CNV.ACCOUNT.DETAILS
*-------------------------------------------------------------------------------------------------------
*-------------------------------------------------------------------------------------------------------
*Description  : This is a conversion routine used to display From.date and Until.date
*In Parameter : N/A
*Out Parameter: O.DATA
*Linked File  : REDO.E.CNV.ACCOUNT.DETAILS
*--------------------------------------------------------------------------------------------------------
*--------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*     Date            Who                              Reference               Description
*    ------          ------                            -----------             --------------
*  30-10-2010       Prabhu N            ODR-2010-08-0031           Initial Creation
*  10-05-2011       GANESH H            PACS00032454               MODIFICATION
* 11-APRIL-2023      Harsha                R22 Auto Conversion  - FM to @FM
* 11-APRIL-2023      Harsha                R22 Manual Conversion - No changes 
*--------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
*---------------------------------------------------------------------------------------------------------
    GOSUB PROCESS
RETURN
*---------------------------------------------------------------------------------------------------------
PROCESS:
*---------------------------------------------------------------------------------------------------------
    LOCATE "BOOKING.DATE" IN ENQ.SELECTION<2,1> SETTING Y.BOOKING.POS THEN
        Y.PERIOD= ENQ.SELECTION<4,Y.BOOKING.POS>
        CHANGE ' ' TO @FM IN Y.PERIOD
        Y.PERIOD<1>=OCONV(Y.PERIOD<1>,'DI')
        Y.PERIOD<2>=OCONV(Y.PERIOD<2>,'DI')
        Y.PERIOD<1>=OCONV(Y.PERIOD<1>,'D')
        Y.PERIOD<2>=OCONV(Y.PERIOD<2>,'D')
        CHANGE @FM TO ' ' IN Y.PERIOD
*PACS00032454-S
        IF Y.PERIOD[13,25] NE '' THEN

            O.DATA=Y.PERIOD[1,12]:"- ":Y.PERIOD[13,25]
        END ELSE

            O.DATA=Y.PERIOD
        END
    END
*PACS00032454-E
RETURN

END
